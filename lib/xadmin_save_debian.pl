# These files contain the functions 'save_passwd_file()', 'save_group_file()'
# and 'create_shadow_line()'... the xxx_debian is Debian specific, since I'm
# breaking the Debian guidelines a little by modifying files that does not
# belong to xAdmin. The xxx_turbo uses my own save routines...
#

# -- C V S  L O G G S --
# $Log: xadmin_save_debian.pl,v $
# Revision 1.4  1998/07/29 23:06:53  turbo
# * More or less rewrote the whole 'save_passwd_file()' function... This time
#   it should work better... I hope... :)
# * Wrote the 'save_group_file()' function.
#
# Revision 1.3  1998/06/21 15:11:41  turbo
# Wrote the base of the 'save_passwd_file()', debian model... Haven't tried
# or debugged it yet though...
#
# Revision 1.2  1998/06/20 21:32:05  turbo
# Added description and CVS log strings...
#
#
#

# ----------------------
# proc: save_passwd_file( user, window, action )
# desc: Add, remove or change a user in the passwd file...
sub save_passwd_file {
    # user   - What user to save to passwd file
    # window - What window should we destroy when we are done?
    # action - add, remove or change
    local($user, $window, $action) = @_;
    my(@pass, $PASS_CONT, $passwd, $i, $added_new_one);

    printf("\nCalling save_passwd_file_debian($user, $window, $action)...\n") if( $DEBUG );

    if( $DEBUG ) {
	printf("Editing passwd/passwd-shadow file(s)\n");

	if( $action eq 'add' ) {
	    printf("    Adding user:   ");
	} elsif( $action eq 'rem' ) {
	    printf("    Removing user: ");
	} else {
	    printf("    Changing user: ");
	}
    }

    # Cycle through the passwd line variables...
    $i = 0; $added_new_one = 0;
    do {
	if( $passwd_line{$i} ) {
	    @pass = split(':', $passwd_line{$i});

	    if( $pass[0] ) {
		$PASS_CONT = 1;

		# =================================
		# ===== P R E P A R A T I O N =====

		# Does the password exists?
		if(! $pass[1] ) {
		    if( ($config{allow_empty_passwords} eq 'yes') || ($config{allow_empty_passwords} eq '1') ) {
			# Make sure that perl does not complain...
			$pass[1] = "";
		    } else {
			# Lock the user...
			$pass[1] = "*";
		    }
		}

		# -----------------------

		# Fix the temporary password variable...
		if( $user eq $pass[0] ) {
		    # Should we lock, unlock or pass through the password?
		    if( $action eq 'lock' ) {
			# Lock account...
			$passwd = "*$pass[1]";
		    } elsif( ($action eq 'unlock') && ($pass[1] =~ /^\*/) ) {
			# Unlock account...
			$passwd = substr($pass[1], 1);
		    } else {
			$passwd = $crypted_password;
		    }
		} else {
		    $passwd = $pass[1];
		}

		# -----------------------

		# Check if we are using SHADOW passwords...
		if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
		    $shadow  = $passwd;
		    $passwd  = "x";
		    $pass[1] = "x";
		} else {
		    $shadow  = $pass[1];
		}

		# -----------------------

#		# Check if we should leave the NIS line last...
#		if( $config{keep_nis_at_end} eq 'yes' || $config{keep_nis_at_end} eq 1 ) {
#		    # Is this the NIS entry?
#		    if( $pass[0] =~ /^\+/ ) {
#			# Yes, make sure we add the user now...
#			$new_uid = $user_id;
#		    } else {
#			$new_uid = 0;
#		    }
#		}
#
#		# -----------------------
#
		# Check to see when and where we should add the line...
		if( (($config{add_user_in_uid_order} eq 'yes') ||
		     ($config{add_user_in_uid_order} eq 1)   ) &&
		    (! $added_new_one ) && (! $new_uid)) {

		    if( ($user_id-1) == $pass[2] ) {
			# Add the user just after the user with one lower UID...
			$new_uid = $user_id;
		    } else {
			$new_uid = 0;
		    }
		} else {
		    $new_uid = 0;
		}

		# ====================================================
		# ===== C R E A T E  T H E  P A S S W D  L I N E =====

		if( $action eq 'add' ) {
		    # ---------------------------------------

		    if( (($new_uid-1) == $pass[2]) && (! $added_new_one) ) {
			$tmp = sprintf("%0.5d", $i);

			# Create a new passwd variable entry...
			$passwd_line{$number_of_users} = "$user\:$passwd\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell\:$tmp";

			# Insert this user in this ($i) position, and push every one else forward one step...
#			&rearange_variable_list('insert', $i+1);

			printf("+") if( $DEBUG );

			$added_new_one = 1; $i++;

			system("/usr/sbin/useradd -d $home_dir -m -g $primary_group_id -s $login_shell -u $user_id $user");
		    } else {
			printf(".") if( $DEBUG );
		    }
		} elsif( $action eq 'rem' ) {
		    # ---------------------------------------

		    if(! $added_new_one ) {
			# Remove the last entry in both the variables, we get one to many for some reason... Strange...
#			&rearange_variable_list('remove', $i);

			printf("-") if( $DEBUG );

			$added_new_one = 1;

			system("/usr/sbin/userdel -r $user");
		    } else {
			printf(".") if( $DEBUG );
		    }
		} elsif( ($action eq 'change') || ($action eq 'lock') || ($action eq 'unlock') ) {
		    # ---------------------------------------

		    if(! $added_new_one ) {
			printf("c") if( $DEBUG );

			$added_new_one = 1;

			system("/usr/sbin/useradd -D -d$home_dir -m -g$primary_group_id -s$login_shell -u $user_id $user");
		    } else {
			printf(".") if( $DEBUG );
		    }
		}
	    } else {
		$PASS_CONT = 0;
	    }
	} else {
	    $PASS_CONT = 0;
	}

	$i++;
    } while( $PASS_CONT );
    printf("\n") if( $DEBUG );

    # -----------------------------------------------------------------

    # How should we display the password...
    if( $config{display_type_passwd} eq 'crypted' ) {
	$mark = $crypted_password;
    } else {
	if( ($config{shadow} eq 'yes') || ($config{shadow} eq '1') ) {
	    $duhhh = $crypted_password;
	    printf("  Duhhh (shadow): '$duhhh'\n") if( $DEBUG );
	} else {
	    $duhhh = $passwd;
	    printf("  Duhhh (passwd): '$duhhh'\n") if( $DEBUG );
	}

	if( $duhhh =~ /^\*/ ) {
	    $mark = "locked";
	} elsif(! $duhhh ) {
	    $mark = "blank";
	} else {
	    $mark = "exists";
	}

	printf("  Mark:           '$mark'\n") if( $DEBUG );
    }
	
    # Update the listbox acordingly...
    if( $action eq 'add' ) {
	# Insert the new user to the listbox to...
	$entry = &listbox_prepare( $userno, $user, $mark, $user_id, $primary_group_id, $user_info, $home_dir, $login_shell);
	$user_listbox->insert('end', $entry);

	# Encrease the number of active users by one...
	$number_of_users++;
     } elsif( $action eq 'rem' ) {
	# Remove the user from the listbox...
	$user_listbox->delete('active', 'active');

	# Decrease the number of active user by one...
	$number_of_users--;
    } elsif( ($action eq 'change') || ($action eq 'lock') || ($action eq 'unlock') ) {
	# Does this new user have a primary group ID (or should we just save the file)?
	if( $primary_group_id) {
	    $user_listbox->delete('active', 'active');

	    # Prepare the listbox entry...
	    $entry = &listbox_prepare( $userno, $user, $mark, $user_id, $primary_group_id, $user_info, $home_dir, $login_shell);

	    # Update the users entry in the listbox...
	    $user_listbox->insert($userno+1, $entry);
	}
    }
}

# ----------------------
# proc: save_group_file( group, window, action )
# desc: Add, remove or change a user/group in the group file...
sub save_group_file {
    # group  - What user to save to passwd file
    # window - What window should we destroy when we are done?
    # action - What to do
    #          new    = Create a new group
    #          sub    = Add a user to an existing group
    #          rem    = Remove a group
    #          change = Change the group/user value
    local($group, $action) = @_;
    my($temp, $i, $j, $k, $added_new_one, $new_gid, $GROUP_CONT, $new_group_entry);
    my($new_shadow_entry, $prev_gid, $entry, $mark);
    my(@grp, @second) = ();

    printf("\nCalling save_group_file($group, $action)...\n") if( $DEBUG );

    if( $DEBUG ) {
	printf("  Editing group/group-shadow file\n") if( $DEBUG );

	if( $action eq 'add' ) {
	    printf("    Adding group:   ");
	} elsif( $action eq 'rem' ) {
	    printf("    Removing group: ");
	} else {
	    printf("    Changing group: ");
	}
    }

    $group    = $primary_group    if(! $group );
    $group_id = $primary_group_id if(! $group_id && !defined($group_id) );

    # Zero some variables...
    $added_new_one = 0; $i = 0; $prev_gid = 0; $new_gid = 0;

    # Read line by line from the old group file...
    do {
	if( $group_line{$i} ) {
	    @grp = split(':', $group_line{$i});

	    if( $grp[0] ) {
		$GROUP_CONT = 1;

		# =================================
		# ===== P R E P A R A T I O N =====

		# Does the password exists?
		if(! $grp[1] ) {
		    if( ($config{allow_empty_passwords} eq 'yes') || ($config{allow_empty_passwords} eq '1') ) {
			# Make sure that perl does not complain...
			$grp[1] = "";
		    } else {
			# Lock the group...
			$grp[1] = "*";
		    }
		}

		# -----------------------

		# Fix the temporary password variable...
		if( $group eq $grp[0] ) {
		    # Should we lock, unlock or pass through the password?
		    if( $action eq 'lock' ) {
			# Lock account...
			$passwd = "*$grp[1]";
		    } elsif( ($action eq 'unlock') && ($grp[1] =~ /^\*/) ) {
			# Unlock account...
			$passwd = substr($grp[1], 1);
		    } else {
			$passwd = $crypted_password;
		    }
		} else {
		    $passwd = $grp[1];
		}

		# -----------------------

		# Check if we are using SHADOW passwords...
		if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
		    $shadow = $passwd;
		    $passwd = "x";
		    $grp[1] = "x";
		} else {
		    $shadow = $grp[1];
		}

		# -----------------------

#		# Check if we should leave the last line last (NIS)...
#		if( $config{keep_nis_at_end} eq 'yes' || $config{keep_nis_at_end} eq 1 ) {
#		    # Is this the NIS entry?
#		    if( $grp[0] =~ /^\+/ ) {
#			# Yes, make sure we add the user now...
#			$new_gid = $group_id;
#		    } else {
#			$new_gid = 0;
#		    }
#		}
#
#		# -----------------------
#
		# Check to see when and where we should add the line...
		if( (($config{add_user_in_uid_order} eq 'yes') ||
		     ($config{add_user_in_uid_order} eq '1') ) &&
		    (! $added_new_one) && (! $new_gid)) {

		    if( ($group_id > $grp[2]) && ($group_id < $prev_gid) ) {
			# Add the group just after the group with one lower GID...
			$new_gid = $group_id;
		    } else {
			$new_gid = 0;
		    }
		} else {
		    $new_gid = 0;
		}

		# ==================================================
		# ===== C R E A T E  T H E  G R O U P  L I N E =====

		if( $action eq 'add' ) {
		    # ---------------------------------------
		    # Create a completly new group...

		    if( (($new_gid > $grp[2]) && ($new_gid < $prev_gid) && (! $added_new_one) ) ) {
			# Create a new group variable entry...
			$group_line{$number_of_groups}  = "$group\:$passwd\:$group_id\:";
			$group_line{$number_of_groups} .= "$group_members" if( $group_members );

			# Should we create the shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    $shadow = $crypted_password;

			    $gshadow_line{$number_of_groups}  = "$group\:$shadow\:\:";
			    $gshadow_line{$number_of_groups} .= "$group_members" if( $groups_members );
			}

			# Insert this user in this ($i) position, and push every one else forward one step...
#			&rearange_groups_list('insert', $i+1);

			printf("+") if( $DEBUG );

			# Skip to the next line...
			$added_new_one = 1; $i++;

			system("/usr/sbin/groupadd -g $group_id $group");
		    } else {
			printf(".") if( $DEBUG );
		    }

		    $prev_gid = $grp[2];
#		} elsif( $action eq 'sub_add') {
#		    # ---------------------------------------
#
#		    $added_new_one = 1;
#
#		    # Add a user to an existing group...
#		    $j = 0;
#		    while( $secondary_groups{$j} ) {
#			@second = split(':', $secondary_groups{$j});
#			# second[0] = User name
#			# second[1] = Group name
#
#			# Is it this group we should add the user to?
#			if( $grp[0] eq $second[1] ) {
#			    if( $grp[3] ) {
#				$grp[3] .= ",$second[0]";
#			    } else {
#				$grp[3]  = $second[0];
#			    }
#			}
#
#			$j++;
#		    }
#
#		    # Create the group line...
#		    $new_group_entry = "$grp[0]\:$passwd\:$grp[2]\:";
#		    if( $grp[3] ) {
#			$new_group_entry .= "$grp[3]\n";
#		    } else {
#			$new_group_entry .= "\n";
#		    }
#
#		    # Should we create the shadow line to?
#		    if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
#			# Yes, create the shadow line...
#			$new_shadow_entry = &create_shadow_line('group', $grp[0]);
#		    }
#
#		    printf(".") if( $DEBUG );
#		} elsif( $action eq 'sub_rem' ) {
#		    # ---------------------------------------
#
#		    $added_new_one = 1;
#
#		    # Remove a user from an existing group...
#		    $j = 0;
#		    while( $rem_groups{$j} ) {
#			@second = split(':', $rem_groups{$j});
#			# second[0] = User name
#			# second[1] = Group name
#
#			# Is it this the group we should remove the user from?
#			if( $second[1] eq $grp[0] ) {
#			    # Yes, we should remove the user from this group...
#			    if( $grp[3] =~ /$second[0]/ ) {
#				# Good, the user is a member of this group...
#				@temp = split('\,', $grp[3]);
#				$k = 0; $grp[3] = "";
#
#				# Put together the users in this group again...
#				while( $temp[$k] ) {
#				    if( $temp[$k] eq $second[0] ) {
#					# This is the user we are looking for...
#					$added_new_one = 1;
#
#					printf("  Removed user '$second[0]' from group '$grp[0]'...\n") if( $DEBUG );
#				    } else {
#					if( $j == 0 ) {
#					    $grp[3] .= $temp[$j];
#					} else {
#					    $grp[3] .= ",$temp[$j]";
#					}
#				    }
#
#				    $k++;
#				}
#			    }
#			}
#
#			$j++;
#		    }
#
#		    # Create the group line...
#		    $new_group_entry = "$grp[0]\:$passwd\:$grp[2]\:";
#		    if( $grp[3] ) {
#			$new_group_entry .= "$grp[3]\n";
#		    } else {
#			$new_group_entry .= "\n";
#		    }
#
#		    # Should we create the shadow line to?
#		    if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
#			# Yes, create the shadow line...
#			$new_shadow_entry = &create_shadow_line('group', $grp[0]);
#		    }
#
#		    printf(".") if( $DEBUG );
#		} elsif( $action eq 'rem') {
#		    # ---------------------------------------
#		    # Remove a group totaly OR remove a user from a group...
#
#		    if( $grp[0] eq $group ) {
#			$new_group_entry = "";
#
#			# Should we create the shadow line to?
#			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
#			    # Yes, create the shadow line...
#			    $new_shadow_entry = "";
#			}
#
#			# Rearange the variables...
#			$j = $i;
#			while( $group_line{$j+1} ) {
#			    $group_line{$j} = $group_line{$j+1};
#			    $j++;
#			}
#
#			# Remove the last variables...
#			$group_line{$j} = "";
#
#			$i--; $added_new_one = 1;
#			printf("-") if( $DEBUG );
#		    } else {
#			# Store the old line...
#			$new_group_entry = "$grp[0]\:$grp[1]\:$grp[2]\:";
#
#			if( $grp[3] ) {
#			    if( $grp[3] =~ /$group/ ) {
#				# Strange, but we might have been called with a username instead of a groupname, which
#				# means that we want to remove a user from a group...
#				@temp = split('\,', $grp[3]);
#				$j = 0; $grp[3] = "";
#
#				while( $temp[$j] ) {
#				    if( $temp[$j] eq $group ) {
#					printf("  Removed user '$group' from '$grp[0]'...\n") if( $DEBUG );
#				    } else {
#					if( $j == 0 ) {
#					    $grp[3] .= $temp[$j];
#					} else {
#					    $grp[3] .= ",$temp[$j]";
#					}
#				    }
#
#				    $j++;
#				}
#			    }
#
#			    $new_group_entry .= "$grp[3]\n";
#			} else {
#			    $new_group_entry .= "\n";
#			}
#
#			# Should we store the old shadow line to?
#			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
#			    # Yes, create the shadow line...
#			    $new_shadow_entry = &create_shadow_line('group', $grp[0]);
#			}
#
#			printf(".") if( $DEBUG );
#		    }
#		} elsif( $action eq 'change' || $action eq 'lock' || $action eq 'unlock' ) {
#		    # ---------------------------------------
#		    # Change the user/group pairs...
#
#		    $added_new_one = 1;
#
#		    $groupno = $i;
#
#		    # Find the right group-line, and change it...
#		    if( $grp[0] eq $group ) {
#			# Store the new line...
#			$new_group_entry = "$group\:$crypted_password\:$group_id\:$group_members\n";
#			printf("+") if( $DEBUG );
#		    } else {
#			# Store the old line...
#			$new_group_entry = "$grp[0]\:$passwd\:$grp[2]\:";
#
#			if( $grp[3] ) {
#			    $new_group_entry .= "$grp[3]\n";
#			} else {
#			    $new_group_entry .= "\n";
#			}
#
#			printf(".") if( $DEBUG );
#		    }
		}

		# Better looking output...
		if(! (($i-59) % 60) ) {
		    # Add a newline after every 60 dot (password line)...
		    printf(" \\\n                     ") if( $DEBUG );
		}
	    } else {
		$GROUP_CONT = 0;
	    }
	} else {
	    $GROUP_CONT = 0;
	}

	$i++;
    } while( $GROUP_CONT );
    printf("\n") if( $DEBUG );

    # ===============

    # How should we display the password...
    if(Exists($main_window_groups)) {
	if( $config{display_type_passwd} eq 'crypted' ) {
	    $mark = $crypted_password;
	} else {
	    if( ($config{shadow} eq 'yes') || ($config{shadow} eq '1') ) {
		$duhhh = $crypted_password;
		printf("  Duhhh (shadow): '$duhhh'\n") if( $DEBUG );
	    } else {
		$duhhh = $passwd;
		printf("  Duhhh (passwd): '$duhhh'\n") if( $DEBUG );
	    }

	    if( $duhhh =~ /^\*/ ) {
		$mark = "locked";
	    } elsif(! $duhhh ) {
		$mark = "blank";
	    } else {
		$mark = "exists";
	    }

	    printf("  Mark:           '$mark'\n") if( $DEBUG );
	}
    }
	
    # Update the listbox acordingly...
    if( $action eq 'add' ) {
	# Insert the new group to the listbox to...
	if( $config{main_func} eq 'groups' ) {
	    $entry  = "";
	    $entry .= size_string( 'right', $group,    $config{size_name});
	    $entry .= size_string( 'left',  $group_id, $config{size_id_number}) . " ";
	    $entry .= size_string( 'right', $mark,     $config{size_passwd_desc});
	    $entry .= $group_members if( $group_members );
	    $group_listbox->insert('end', $entry);
	}

	# Encrease the number of active groups by one...
	$number_of_groups++;
     } elsif( $action eq 'rem' ) {
	 # Remove the group from the listbox...
	 if( $config{main_func} eq 'groups' ) {
	     $group_listbox->delete('active', 'active');
	 }
	 
	# Decrease the number of active groups by one...
	$number_of_groups--;
    } elsif( ($action eq 'change') || ($action eq 'lock') || ($action eq 'unlock') ) {
	# Does this new user have a primary group ID (or should we just save the file)?
	if( $primary_group_id && Exists($main_window_groups) ) {
	    $group_listbox->delete('active', 'active');

	    $entry  = "";
	    $entry .= size_string( 'right', $group,    $config{size_name});
	    $entry .= size_string( 'left',  $group_id, $config{size_id_number}) . " ";
	    $entry .= size_string( 'right', $passwd,   $config{size_passwd_desc});
	    $entry .= $group_members if( $group_members );

	    # Update the users entry in the listbox...
	    $group_listbox->insert('end', $entry);
	}
    }
}

1;
