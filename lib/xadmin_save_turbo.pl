# These files contain the functions 'save_passwd_file()', 'save_group_file()'
# and 'create_shadow_line()'... the xxx_debian is Debian specific, since I'm
# breaking the Debian guidelines a little by modifying files that does not
# belong to xAdmin. The xxx_turbo uses my own save routines...
#

# -- C V S  L O G G S --
# $Log: xadmin_save_turbo.pl,v $
# Revision 1.6  1998/08/01 06:43:21  turbo
# chmod() and chown() the group files, not the passwd files after we have created/
# edited the group files...
#
# Revision 1.5  1998/06/26 13:59:57  turbo
# * When we are rearranging the variable list (passwd/shadow/group/gshadow) we should
#   insert the user 'in the feature' (one step ahead).
# * When we have added the new user to the global user variable lists
#   (%passwd_line and %shadow_line) and we have rearranged the list, we SHOULD
#   NOT write the line to the passwd/shadow file... We just 'recycle' the
#   variable and do it in the next run, preferably with a 'next', but that don't
#   work for some reason, _VERY_ strange error messages!! Instead we set 'dont_save'
#   to FALSE every time we start the loop, and to TRUE that one time we have a
#   new user... Ugly, but it works... :) This means that we don't create any
#   '$new_{group|passwd}_line' this time, but takes it in the next iteration of
#   the loop...
# * Removed the third option in the 'create_shadow_line()' and optimized the
#   function according to that. We don't use the function to create a shadow line
#   if there is a new user to be added to the files any more, we just take the
#   variable again, in the next iteration of the loop...
# * Optimized the function 'create_shadow_line()' quite a lot, one thing is if
#   we are to create a user shadow line, we copies the whole '%shadow_line' to
#   '%line', and if we should create a group shadow line, we copy the whole
#   '%gshadow_line' to '%line' and then only use the '%line' to find the correct
#   user/group. Also see above for more changes... Saved ALLOT of lines of code
#   this way... :)
# * Some more/different debug output... Removed some, added some...
#
# Revision 1.4  1998/06/23 13:44:05  turbo
# * New functions:
#     rearange_passwd_list() - This was renamed from 'rearange_variable_list()'
#                              because I needed the next function.
#     rearange_groups_list() - Rearranges the groups variable list, inserts new
#                              or remove last entry...
# * Added a lot of '&' to indicate a 'home made' function... The dark blue
#   chins so bright and beautifully in X... :)
# * Changed an option in the 'save_group_file()'... The action (third param can
#   now be: add/sub_add/sub_rem/rem/change/lock/unlock...
# * Finaly got the 'save_group_file()' to work as expected, without problems.
#   Don't forget to change the listbox when we have added/removed/changed a
#   group...
# * Extra comments and changes in the debug output...
#
# Revision 1.3  1998/06/21 15:14:27  turbo
# * Changes in the debug output
# * Moved the function 'rearange_variable_list()' here instead of the script,
#   it is only needed by my own 'save_passwd_file()' no where else...
# * Changes in the creation of the passwd variable... Worked when adding users
#   but not when removing/changing... Now it works in all directions... :)
#
# Revision 1.2  1998/06/20 21:37:55  turbo
# * Fixed some spelling errors and debug output formating...
# * Do _NOT_ add a newline on the new passwd line
# * If we haven't created the new line (in the 'create_shadow_line()') and
#   we don't have a new user to add, cycle through the shadow lines, finding
#   the correct line...
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
    #          add    = Create a new user
    #          rem    = Remove a user
    #          change = Change the user value
    local($user, $window, $action) = @_;
    my($temp, $i, $j, $k, $added_new_one, $new_uid, $PASS_CONT, $new_passwd_entry);
    my($new_shadow_entry, $duhhh, $number, $dont_save);
    my($cancel) = "Oki";

    printf("\nCalling save_passwd_file($user, $window, $action)...\n") if( $DEBUG );

    while(! &lock_passwd() ) {
    # Output a little dialog saying what we are doing...
	$wait_box->configure(-txt1 => "Can not lock the passwd/shadow files.");
	$wait_box->configure(-txt2 => 'Sleeping for five seconds...');
	$wait_box->update;

	sleep(5);

	$wait_box->unShow;
    }

    if(! $SORT_FILE ) {
	# We should sort the passwd file by UID's...
	$temp = $config{sort_by};
	$config{sort_by} = 'uid';
	sort_list('passwd');
    }

    # Open the new passwd file...
    open(NEW_PASSWD, ">$config{passwd_file}.new") || printf("\n  WARNING: Could not open $config{passwd_file}.new, $!\n");

    if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	# Open the new shadow file here...
	open(NEW_SHADOW, ">$config{shadow_passwd}.new")
	    || die "\n  ERROR: Could not open $config{shadow_passwd}.new, $!\n";
    }

    if( $DEBUG ) {
	printf("  Editing passwd/passwd-shadow file(s)\n");

	if( $action eq 'add' ) {
	    printf("    Adding user:   ");
	} elsif( $action eq 'rem' ) {
	    printf("    Removing user: ");
	} else {
	    printf("    Changing user: ");
	}
    }

    # Zero some variables...
    $added_new_one = 0; $i = 0; $new_uid = 0;
    $user_id = 0 if(! $user_id);

    # Cycle through the passwd line variables...
    do {
	$dont_save = 0;

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

		# Check if we should leave the NIS line last...
		if( $config{keep_nis_at_end} eq 'yes' || $config{keep_nis_at_end} eq 1 ) {
		    # Is this the NIS entry?
		    if( $pass[0] =~ /^\+/ ) {
			# Yes, make sure we add the user now...
			$new_uid = $user_id;
		    } else {
			$new_uid = 0;
		    }
		}

		# -----------------------

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
			# We should add the new user right about here!
			# ++++++++++++++++++++++++++++++++++++++++++++
			$tmp = sprintf("%0.5d", $i);

			# Create a new passwd variable entry...
			$passwd_line{$number_of_users} = "$user\:$passwd\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell\:$tmp";

			# Should we create the shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    $shadow = $crypted_password;

			    $shadow_line{$number_of_users} = "$user\:$shadow\:$config{shad_change}\:$config{shad_allowed}\:$config{shad_required}\:$config{shad_warn}\:$config{shad_inactive}\:$config{shad_expired}\:";
			}

			# -----------------------

			# Insert this user in this ($i) position, and push every one else forward one step...
			&rearange_passwd_list('insert', $i+1);

			$added_new_one = 1;

			if( $DEBUG ) {
			    printf("+");
#			    printf("\n  1. (%2d) Old: $pass[0]\:$pass[1]\:$pass[2]\:$pass[3]\:$pass[4]\:$pass[5]:$pass[6]\n", $i);
#			    printf(   "          New: $passwd_line{$number_of_users}\n");
#
#			    if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
#				printf("     (%2d)      $user\:$shadow\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell\n", $i+1);
#				printf("          Shd: $new_shadow_entry\n");
#			    }
			}

			# Skip to the next line...
			$dont_save = 1;
		    } else {
			# Add an existing, old user here!
			# +++++++++++++++++++++++++++++++

			$new_passwd_entry = "$pass[0]\:$passwd\:$pass[2]\:$pass[3]\:$pass[4]\:$pass[5]:$pass[6]\n";

			# Should we create the shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = &create_shadow_line('user', $pass[0]);
			}

			if( $DEBUG ) {
			    printf(".");

#			    printf("\n  2. (%2d) Old: $new_passwd_entry          Shd: $new_shadow_entry", $i)
#				if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) );
			}
		    }
		} elsif( $action eq 'rem' ) {
		    # ---------------------------------------

		    if( $user eq $pass[0] ) {
			$new_passwd_entry = "";

			# Should we create the shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = "";
			}

			# Remove the last entry in both the variables, we get one to many for some reason... Strange...
			&rearange_passwd_list('remove', $i);

			# Skip to the previous variable...
			$i--;

			$added_new_one = 1;
			printf("-") if( $DEBUG );
		    } else {
			# Store the old line...
			$new_passwd_entry = "$pass[0]\:$passwd\:$pass[2]\:$pass[3]\:$pass[4]\:$pass[5]:$pass[6]\n";

			# Should we store the old shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = &create_shadow_line('user', $pass[0]);
			}

			printf(".") if( $DEBUG );
		    }
		} elsif( ($action eq 'change') || ($action eq 'lock') || ($action eq 'unlock') ) {
		    # ---------------------------------------

		    $added_new_one = 1;

		    # Find the users passwd-line, and change it...
		    if( $user eq $pass[0] ) {
			$userno = $i;
			$tmp    = sprintf("%0.5d", $userno);

			# Restore the new entry...
			if( ($config{shadow} eq 'yes') || ($config{shadow} eq '1') ) {
			    $crypted_password     = $shadow;
			    $passwd_line{$userno} = "$user\:$shadow\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell\:$tmp";
			} else {
			    $passwd_line{$userno} = "$user\:$passwd\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell\:$tmp";
			}
			$new_passwd_entry = "$user\:$passwd\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell\n";

			# Should we store the old shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = &create_shadow_line('user', $user);
			}

			printf("c") if( $DEBUG );
		    } else {
			# Store the old line...
			$new_passwd_entry = "$pass[0]\:$passwd\:$pass[2]\:$pass[3]\:$pass[4]\:$pass[5]:$pass[6]\n";

			# Should we store the old shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = &create_shadow_line('user', $pass[0]);
			}

			printf(".") if( $DEBUG );
		    }
		}

		# =====================================
		# ===== O U T P U T  T O  F I L E =====

		# Better looking output...
		if(! (($i-59) % 60) ) {
		    # Add a newline after every 60 dot (password line)...
		    printf(" \\\n                    ") if( $DEBUG );
		}

		# Print the new passwd line...
		printf NEW_PASSWD $new_passwd_entry if(!$dont_save);

		if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
		    # Print the new shadow line...
		    printf NEW_SHADOW $new_shadow_entry if(!$dont_save);
		}
	    } else {
		$PASS_CONT = 0;
	    }
	} else {
	    $PASS_CONT = 0;
	}

	$i++ if(!$dont_save);
    } while( $PASS_CONT );

    # ===============

    # Make sure the new user is added...
    if(! $added_new_one ) {
	# Add the password...
	if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	    $passwd = "x";
	    $shadow = $crypted_password;
	} else {
	    $passwd = $crypted_password;
	}

	$tmp = sprintf("%0.5d", $userno);

	$new_passwd_entry     = "$user\:$passwd\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell";
	$passwd_line{$userno} = "$user\:$crypted_password\:$user_id\:$primary_group_id\:$user_info\:$home_dir\:$login_shell\:$tmp";

	# Print the new line to the passwd file...
	printf NEW_PASSWD "$new_passwd_entry\n";

	# Create and print the new shadow line...
	if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	    $new_shadow_entry = "$user\:$shadow\:$config{shad_change}\:$config{shad_allowed}\:$config{shad_required}\:$config{shad_warn}\:$config{shad_inactive}\:$config{shad_expired}\:\n";

	    printf NEW_SHADOW $new_shadow_entry;
	}

	printf("\n    Added NEW:   $user") if( $DEBUG );
    }
    printf("\n") if( $DEBUG );

    # Close the passwd files...
    close( NEW_PASSWD );

    if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	# Close the shadow file...
	close( NEW_SHADOW );
    }

    # ===============

    if( $rem_from_group ) {
	# We should remove this user from a secondary group?
	&save_group_file($user, 'sub_rem');
    } elsif( $add_to_group ) {
	# If we have more than one group, add the user in the group file...
	&save_group_file('', 'sub_add');
    }

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

    # -----------------------------------------------------------------

    # Rename the passwd files...
    if(! $play_it_safe ) {
	rename($config{passwd_file}, "$config{passwd_file}.old");
	rename("$config{passwd_file}.new", $config{passwd_file});
    }

    if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	# Rename the shadow files...
	if(! $play_it_safe ) {
	    rename($config{shadow_passwd}, "$config{shadow_passwd}.old");
	    rename("$config{shadow_passwd}.new", $config{shadow_passwd});
	}

	# Change mode on the shadow file, should only be rw by root...
	chown( 0, 42, $config{shadow_passwd}, "$config{shadow_passwd}.old" );
	chmod( 0640, $config{shadow_passwd}, "$config{shadow_passwd}.old" );
    } else {
	# Delete the shadow files...
	unlink( $config{shadow_passwd} );
	unlink( "$config{shadow_passwd}.new" );
	unlink( "$config{shadow_passwd}.old" );
    }

    if(! $SORT_FILE ) {
	# Resort file like we had it sorted BEFORE the saving...
	$config{sort_by} = $temp;
	&sort_list($config{sort_by});
    }
}

# ----------------------
# proc: save_group_file( group, window, action )
# desc: Add, remove or change a user/group in the group file...
sub save_group_file {
    # group  - What user to save to passwd file
    # action - What to do
    #          add     = Create a new group
    #          sub_add = Add a user to an existing group
    #          sub_rem = Remove a user from an existing group
    #          rem     = Remove a group
    #          change  = Change the group/user value
    #          lock    = Lock the group
    #          unlock  = Lock the group
    local($group, $action) = @_;
    my($temp, $i, $j, $k, $added_new_one, $new_gid, $GROUP_CONT, $new_group_entry);
    my($new_shadow_entry, $prev_gid, $entry, $mark);
    my(@grp, @second) = ();

    printf("\nCalling save_group_file($group, $action)...\n") if( $DEBUG );

    # Open the new group file...
    open(NEW_GROUP, ">$config{group_file}.new") || die "Could not open $config{group_file}.new, $!\n";

    if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	# Open the new shadow file here...
	open(NEW_SHADOW, ">$config{shadow_group}.new") || die "Could not open $config{shadow_group}.new, $!\n";
    }

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
	$dont_save = 0;

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

		# Check if we should leave the last line last (NIS)...
		if( $config{keep_nis_at_end} eq 'yes' || $config{keep_nis_at_end} eq 1 ) {
		    # Is this the NIS entry?
		    if( $grp[0] =~ /^\+/ ) {
			# Yes, make sure we add the user now...
			$new_gid = $group_id;
		    } else {
			$new_gid = 0;
		    }
		}

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
			# We should add the new group right about here!
			# ++++++++++++++++++++++++++++++++++++++++++++

			# Create a new passwd variable entry...
			$group_line{$number_of_groups}  = "$group\:$passwd\:$group_id\:";
			$group_line{$number_of_groups} .= "$group_members" if( $group_members );

			# Should we create the shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    $shadow = $crypted_password;

			    $gshadow_line{$number_of_groups}  = "$group\:$shadow\:\:";
			    $gshadow_line{$number_of_groups} .= "$group_members" if( $groups_members );
			}

			# Insert this user in this ($i) position, and push every one else forward one step...
			&rearange_groups_list('insert', $i+1);

			$added_new_one = 1;

			if( $DEBUG ) {
			    printf("+");

#			    printf("\n  1. (%2d) Old: $grp[0]\:$grp[1]\:$grp[2]\:", $i);
#			    printf("$grp[3]") if( $grp[3] );
#			    printf("\n");
#
#			    printf(   "          New: $group_line{$number_of_groups}\n");
#
#			    if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
#				printf("     (%2d)      $group\:$shadow\:$group_id\:", $i);
#				printf("$group_members") if( $group_members );
#				printf("\n");
#
#				printf("          Shd: $gshadow_line{$number_of_groups}\n");
#			    }
			}

			# Skip to the next line...
			$dont_save = 1;
		    } else {
			# Add an existing, old group here!
			# +++++++++++++++++++++++++++++++

			$new_group_entry  = "$grp[0]\:$passwd\:$grp[2]\:";
			$new_group_entry .= "$grp[3]" if( $grp[3] );
			$new_group_entry .= "\n";

			# Should we create the shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = &create_shadow_line('group', $grp[0]);
			}

			if( $DEBUG ) {
			    printf(".");

#			    printf("\n  2. (%2d) Old: $new_group_entry          Shd: $new_shadow_entry", $i)
#				if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) );
			}
		    }

		    $prev_gid = $grp[2];
		} elsif( $action eq 'sub_add') {
		    # ---------------------------------------

		    $added_new_one = 1;

		    # Add a user to an existing group...
		    $j = 0;
		    while( $secondary_groups{$j} ) {
			@second = split(':', $secondary_groups{$j});
			# second[0] = User name
			# second[1] = Group name

			# Is it this group we should add the user to?
			if( $grp[0] eq $second[1] ) {
			    if( $grp[3] ) {
				$grp[3] .= ",$second[0]";
			    } else {
				$grp[3]  = $second[0];
			    }
			}

			$j++;
		    }

		    # Create the group line...
		    $new_group_entry = "$grp[0]\:$passwd\:$grp[2]\:";
		    if( $grp[3] ) {
			$new_group_entry .= "$grp[3]\n";
		    } else {
			$new_group_entry .= "\n";
		    }

		    # Should we create the shadow line to?
		    if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			# Yes, create the shadow line...
			$new_shadow_entry = &create_shadow_line('group', $grp[0]);
		    }

		    printf(".") if( $DEBUG );
		} elsif( $action eq 'sub_rem' ) {
		    # ---------------------------------------

		    $added_new_one = 1;

		    # Remove a user from an existing group...
		    $j = 0;
		    while( $rem_groups{$j} ) {
			@second = split(':', $rem_groups{$j});
			# second[0] = User name
			# second[1] = Group name

			# Is it this the group we should remove the user from?
			if( $second[1] eq $grp[0] ) {
			    # Yes, we should remove the user from this group...
			    if( $grp[3] =~ /$second[0]/ ) {
				# Good, the user is a member of this group...
				@temp = split('\,', $grp[3]);
				$k = 0; $grp[3] = "";

				# Put together the users in this group again...
				while( $temp[$k] ) {
				    if( $temp[$k] eq $second[0] ) {
					# This is the user we are looking for...
					$added_new_one = 1;

					printf("  Removed user '$second[0]' from group '$grp[0]'...\n") if( $DEBUG );
				    } else {
					if( $j == 0 ) {
					    $grp[3] .= $temp[$j];
					} else {
					    $grp[3] .= ",$temp[$j]";
					}
				    }

				    $k++;
				}
			    }
			}

			$j++;
		    }

		    # Create the group line...
		    $new_group_entry = "$grp[0]\:$passwd\:$grp[2]\:";
		    if( $grp[3] ) {
			$new_group_entry .= "$grp[3]\n";
		    } else {
			$new_group_entry .= "\n";
		    }

		    # Should we create the shadow line to?
		    if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			# Yes, create the shadow line...
			$new_shadow_entry = &create_shadow_line('group', $grp[0]);
		    }

		    printf(".") if( $DEBUG );
		} elsif( $action eq 'rem') {
		    # ---------------------------------------

		    # Remove a group totaly OR remove a user from a group...

		    if( $grp[0] eq $group ) {
			$new_group_entry = "";

			# Should we create the shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = "";
			}

			# Rearange the variables...
			$j = $i;
			while( $group_line{$j+1} ) {
			    $group_line{$j} = $group_line{$j+1};
			    $j++;
			}

			# Remove the last variables...
			$group_line{$j} = "";

			$i--; $added_new_one = 1;
			printf("-") if( $DEBUG );
		    } else {
			# Store the old line...
			$new_group_entry = "$grp[0]\:$grp[1]\:$grp[2]\:";

			if( $grp[3] ) {
			    if( $grp[3] =~ /$group/ ) {
				# Strange, but we might have been called with a username instead of a groupname, which
				# means that we want to remove a user from a group...
				@temp = split('\,', $grp[3]);
				$j = 0; $grp[3] = "";

				while( $temp[$j] ) {
				    if( $temp[$j] eq $group ) {
					printf("  Removed user '$group' from '$grp[0]'...\n") if( $DEBUG );
				    } else {
					if( $j == 0 ) {
					    $grp[3] .= $temp[$j];
					} else {
					    $grp[3] .= ",$temp[$j]";
					}
				    }

				    $j++;
				}
			    }

			    $new_group_entry .= "$grp[3]\n";
			} else {
			    $new_group_entry .= "\n";
			}

			# Should we store the old shadow line to?
			if( ($config{shadow} eq 'yes' || $config{shadow} eq 1) ) {
			    # Yes, create the shadow line...
			    $new_shadow_entry = &create_shadow_line('group', $grp[0]);
			}

			printf(".") if( $DEBUG );
		    }
		} elsif( $action eq 'change' || $action eq 'lock' || $action eq 'unlock' ) {
		    # ---------------------------------------
		    # Change the user/group pairs...

		    $added_new_one = 1;

		    $groupno = $i;

		    # Find the right group-line, and change it...
		    if( $grp[0] eq $group ) {
			# Store the new line...
			$new_group_entry = "$group\:$crypted_password\:$group_id\:$group_members\n";
			printf("+") if( $DEBUG );
		    } else {
			# Store the old line...
			$new_group_entry = "$grp[0]\:$passwd\:$grp[2]\:";

			if( $grp[3] ) {
			    $new_group_entry .= "$grp[3]\n";
			} else {
			    $new_group_entry .= "\n";
			}

			printf(".") if( $DEBUG );
		    }
		}

		# =====================================
		# ===== O U T P U T  T O  F I L E =====

		# Better looking output...
		if(! (($i-59) % 60) ) {
		    # Add a newline after every 60 dot (password line)...
		    printf(" \\\n                     ") if( $DEBUG );
		}

		# Print the new line to the group file...
		printf NEW_GROUP $new_group_entry if(!$dont_save);

		# Print the new shadow line...
		if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
		    printf NEW_SHADOW $new_shadow_entry if(!$dont_save);
		}
	    } else {
		$GROUP_CONT = 0;
	    }
	} else {
	    $GROUP_CONT = 0;
	}

	$i++ if(!$dont_save);
    } while( $GROUP_CONT );

    # ===============

    # Make sure the new group is added...
    if(! $added_new_one ) {
	# Add the password...
	if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	    $passwd = "x";
	    $shadow = $crypted_password;
	} else {
	    $passwd = $crypted_password;
	}

	$group_line{$groupno}  = "$group\:$passwd\:$group_id\:";
	$group_line{$groupno} .= "$group_members" if( $group_members );

	$new_group_entry .= "$group_line{$groupno}\n";

	# Print the new line to the passwd file...
	printf NEW_GROUP $new_group_entry;

	if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	    $new_shadow_entry  = "$group\:$shadow\:$group_id\:";
	    $new_shadow_entry .= "$group_members" if( $group_members );
	    $new_shadow_entry .= "\n";

	    # Print the new line to the passwd file...
	    printf NEW_SHADOW $new_shadow_entry;
	}

	printf("\n    Added NEW: $group") if( $DEBUG );
    }
    printf("\n") if( $DEBUG );

    # Close the passwd files...
    close( NEW_GROUP );

    if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	# Close the shadow file...
	close( NEW_SHADOW );
    }

    # -----------------------------------------------------------------

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

    # -----------------------------------------------------------------

    # Rename the file...
    if(! $play_it_safe ) {
	rename($config{group_file}, "$config{group_file}.old");
	rename("$config{group_file}.new", $config{group_file});
    }

    if( $config{shadow} eq 'yes' || $config{shadow} eq 1 ) {
	# Rename the shadow files...
	if(! $play_it_safe ) {
	    rename($config{shadow_group}, "$config{shadow_group}.old");
	    rename("$config{shadow_group}.new", $config{shadow_group});

	    # Change mode on the shadow file, should only be rw by root...
	    chown( 0, 42, $config{shadow_group}, "$config{shadow_group}.old" );
	    chmod( 0640, $config{shadow_group}, "$config{shadow_group}.old" );
	}
    } else {
	# Delete the shadow files...
	unlink( $config{shadow_group} );
	unlink( "$config{shadow_group}.new" );
	unlink( "$config{shadow_group}.old" );
    }
}

# ----------------------
# proc: create_shadow_line( type, old_user, new_user )
# desc: Create a line that is to be writen to the shadow file...
sub create_shadow_line {
    local($type, $old) = @_;
    my($i, $new_line, $user, @shad, %line);

    if( $type eq 'user' ) {
	%line = %shadow_line;
    } else {
	%line = %gshadow_line;
    }

    $i = 0;
    while( $line{$i} ) {
	# We have a previous shadow line, use that one...
	@shad = split(':', $line{$i});

	if( $old eq $shad[0] ) {
	    $new_line = "$old\:";

	    if( $type eq 'user' ) {
		if( $shad[1] ) {
		    $new_line .= "$shad[1]";
		} elsif( $shadow ) {
		    $new_line .= "$shadow";
		}
	    } else {
		$new_line .= "$shad[1]" if( $shad[1] );
	    }
	    $new_line .="\:";

	    $new_line .= "$shad[2]" if( $shad[2] );	        $new_line .="\:";

	    if( $type eq 'user' ) {
		$new_line .= "$shad[3]" if( $shad[3] );		$new_line .= "\:";
		$new_line .= "$shad[4]" if( $shad[4] );		$new_line .= "\:";
		$new_line .= "$shad[5]" if( $shad[5] );		$new_line .= "\:";
		$new_line .= "$shad[6]" if( $shad[6] );		$new_line .= "\:";
		$new_line .= "$shad[7]" if( $shad[7] );		$new_line .= "\:";
		$new_line .= "$shad[8]" if( $shad[8] );
	    } else {
		# This is a group line. Add the group members, if any, here...
		if( $shad[3] ) {
		    $new_line .= $shad[3];
		}
	    }

	    $new_line .="\n";
	}

	$i++;
    }

    if(! $new_line ) {
	# Add the old user/group...
	printf("No new shadow line...\n") if( $DEBUG );

	$i = 0;
	while( $line{$i} ) {
	    # We have a previous shadow line, use that one...
	    $user = (split(':', $line{$i}))[0];

	    $new_line = $line{$i} . "\n" if( $old eq $user );

	    $i++;
	}
    }

    # Close the wait box...
    $wait_box->unShow;

    # Return the newly created line...
    return( $new_line );
}

# ----------------------
# proc: rearange_passwd_list( command, start )
# desc: Rearange the passwd variable list, insert new or remove last
sub rearange_passwd_list {
    local($cmd, $pos) = @_;
    my($i, $tot, $tmp);

    # Find total number of positions in the passwd file,
    # just for fun... :)
    $i = $pos + 1;
    while( $passwd_line{$i} ) {
	$i++;
    }
    $tot = $i - 1;
    print "\n POS:     $pos\n PAS tot: $tot\n" if($DEBUG);

    # Insert or remove a position...
    if( $cmd eq 'insert' ) {
	$tmp = $passwd_line{$tot};

	for( $i = $tot; $i >= $pos; $i-- ) {
	    $passwd_line{$i+1} = $passwd_line{$i};
	    printf(" PAS %3d: $passwd_line{$i}\n", $i+1) if($DEBUG);
	}

	$passwd_line{$pos} = $tmp;
	printf("+PAS %3d: $passwd_line{$pos}\n\n", $pos) if($DEBUG);
	undef $passwd_line{$tot+1};
    } else {
	for( $i = $pos; $passwd_line{$i+1}; $i++ ) {
	    $passwd_line{$i} = $passwd_line{$i+1};
	}

	print "-PAS i:   $i\n\n" if($DEBUG);
	undef $passwd_line{$i};
    }

    # ======================================================

    # Fix the shadow entry to?
    if( ($config{shadow} eq 'yes') || ($config{shadow} eq '1') ) {
	# Find total number of positions in the shadow file,
	# still just for fun... :)
	$i = $pos + 1;
	while( $shadow_line{$i} ) {
	    $i++;
	}
	$tot = $i - 1;
	print " SHD tot: $tot\n" if($DEBUG);

	# Insert or remove a position...
	if( $cmd eq 'insert' ) {
	    $tmp = $shadow_line{$tot};

	    for( $i = $tot; $i >= $pos; $i-- ) {
		$shadow_line{$i+1} = $shadow_line{$i};
		printf(" SHD %3d: $shadow_line{$i}\n", $i+1) if($DEBUG);
	    }

	    $shadow_line{$pos} = $tmp;
	    printf("+GRP %3d: $shadow_line{$pos}\n", $pos) if($DEBUG);
	    undef $shadow_line{$tot+1};
	} else {
	    for( $i = $pos; $shadow_line{$i+1}; $i++ ) {
		$shadow_line{$i} = $shadow_line{$i+1};
	    }

	    print "-SHD i:   $i\n" if($DEBUG);
	    undef $shadow_line{$i};
	}
    }
}

# ----------------------
# proc: rearange_groups_list( command, start )
# desc: Rearange the group variable list, insert new or remove last
sub rearange_groups_list {
    local($cmd, $pos) = @_;
    my($i, $tot, $tmp);

    # Find total number of positions in the group file,
    # just for fun... :)
    $i = $pos + 1;
    while( $group_line{$i} ) {
	$i++;
    }
    $tot = $i - 1;
    print "\n POS:     $pos\n GRP tot: $tot\n" if($DEBUG);

    # Insert or remove a position...
    if( $cmd eq 'insert' ) {
	$tmp = $group_line{$tot};

	for( $i = $tot; $i >= $pos; $i-- ) {
	    $group_line{$i+1} = $group_line{$i};
	    printf(" GRP %3d: $group_line{$i}\n", $i+1) if($DEBUG);
	}

	$group_line{$pos} = $tmp;
	printf("+GRP %3d: $group_line{$pos}\n\n", $pos) if($DEBUG);
	undef $group_line{$tot+1};
    } else {
	for( $i = $pos; $group_line{$i+1}; $i++ ) {
	    $group_line{$i} = $group_line{$i+1};
	}

	print "-GRP i:   $i\n\n" if($DEBUG);
	undef $group_line{$i};
    }

    # ======================================================

    # Fix the shadow entry to?
    if( ($config{shadow} eq 'yes') || ($config{shadow} eq '1') ) {
	# Find total number of positions in the group shadow file,
	# still just for fun... :)
	$i = $pos + 1;
	while( $gshadow_line{$i} ) {
	    $i++;
	}
	$tot = $i - 1;
	print " SHD tot: $tot\n" if($DEBUG);

	# Insert or remove a position...
	if( $cmd eq 'insert' ) {
	    $tmp = $gshadow_line{$tot};

	    for( $i = $tot; $i >= $pos; $i-- ) {
		$gshadow_line{$i+1} = $gshadow_line{$i};
		printf(" SHD %3d: $gshadow_line{$i}\n", $i+1) if($DEBUG);
	    }

	    $gshadow_line{$pos} = $tmp;
	    printf("+SHD %3d: $gshadow_line{$pos}\n", $pos) if($DEBUG);
	    undef $gshadow_line{$tot+1};
	} else {
	    for( $i = $pos; $gshadow_line{$i+1}; $i++ ) {
		$gshadow_line{$i} = $gshadow_line{$i+1};
	    }

	    print "-SHD i:   $i\n" if($DEBUG);
	    undef $gshadow_line{$i};
	}
    }
}

1;
