# ----------------------
# $Log: xadmin.pl,v $
# Revision 1.38  1998/08/30 20:25:12  turbo
# * When adding a interface, add the line 'interface eth0 (ethernet)' for example,
#   in the 'Interfaces' listbox...
# * When we are done configuring a interface, setup the variables and insert
#   it into the 'Interfaces' listbox, THEN remove the window...
# * When getting a listbox number, double check to see that we have a valid
#   user or group to edit...
#
# Revision 1.37  1998/08/01 06:42:30  turbo
# Forgot a 'if( $DEBUG )' on a printf()...
#
# Revision 1.36  1998/03/21 16:22:02  turbo
# Make sure we can find the domainname somehow, if not, set it to 'unset',
# to indicate that it could not be found...
# Thanx to 'Yann Dirson <ydirson@a2points.com>' for reporting this...
#
# Revision 1.35  1998/03/04 16:05:13  turbo
# * Commented out some debug messages conserning the creation of a users
#   home directory, don't need it...
#
# Revision 1.34  1998/02/22 00:17:54  turbo
# Make sure we only add/remember any NEW interface/device to the hosts entries...
#
# Revision 1.33  1998/02/21 18:16:52  turbo
# * Changed the 'Set system clock' in the date editors buttons to: 'Set date'
# * Added the button 'Set zone' in the date editors buttons
#
# Revision 1.32  1998/02/15 20:49:24  turbo
# Fixed the bugs that crouped up when I upgraded perl. Make sure we check for
# eof on the file handle when reading/loading a file...
#
# Revision 1.31  1998/01/13 12:01:30  turbo
# * Added support for choosing a user and automatic GID selection to the button
#   creation function...
# * Using 'File::Find', 'File::Copy' instead of home made functions, therefor
#   removed the functions 'dirname()' and 'find_dir()' and added the function
#   'wanted()' which is used by 'File::Find::find'...
#
# Revision 1.30  1998/01/12 03:51:26  turbo
# * When we are saving the group file, we don't need the window, removed that
#   option to the function...
# * Make sure the string we are trying to size up (in the 'size_string()'
#   function) is not '0' (could be root's UID/GID)...
#
# Revision 1.29  1997/10/28 16:35:38  turbo
# Changed the names of the buttons in the DNS editors window...
#
# Revision 1.28  1997/10/18 00:47:04  turbo
# * If we call the 'get_listentry()' with argument 'remove secondary group',
#   all we have to do is split up the earlier saved secondary group variable,
#   and increase the number of groups/users-from-groups to remove (rem_from_group)
#
# Revision 1.27  1997/10/14 18:09:46  turbo
# * Added support to add a user to a group, and to remove a user from a group...
#
# Revision 1.26  1997/10/12 16:14:38  turbo
# When reading the config file, first fill in all the default values, THEN
# exchange the default values with the values we find in the config file...
#
# Revision 1.25  1997/10/10 04:38:27  turbo
# * Should be 'Add user' instead of 'Save' in the 'Add user' window...
# * Forgot more 'if( $DEBUG )' in the printf's... I wonder how many I have
#   left to forget... :)
#
# Revision 1.24  1997/10/07 15:17:50  turbo
# When checking if a configvariable is 'YES', also check if it is '1' (just in
# case...).
#
# Revision 1.23  1997/09/24 19:23:37  turbo
# Added support for the Date/Time editor in the 'main_buttons()' function...
#
# Revision 1.22  1997/09/24 16:46:55  turbo
# * Added some more 'main_buttons()' choices...
# * Added support for the 'choose_group()' function in the 'get_list_entry()'
#   function...
#
# Revision 1.21  1997/09/22 21:42:29  turbo
# * Instead of 'Deactivate/Reactivate', call it 'Lock/Unlock'... Maby more
#   correct English?
# * In the 'edit_{user,group}()' function, have the main buttons in another
#   order: 'Save/Quota/Cancel' instead of 'Save/Cancel/Quota'.
# * When removing a user/group, make sure we zero out the correct variable,
#   and then rearange the variable list...
#
# Revision 1.20  1997/09/22 03:27:30  turbo
# * Added the 'Cancel' button to a lot of the sub functions in both the DNS
#   and NET editor... Just closes the correct window...
# * When adding a interface, update the hosts list acordingly and don't forget
#   the variable lists...
#
# Revision 1.19  1997/09/21 16:19:04  turbo
# * Change the variable '$config{tcp_quota}' to '$config{display_tcp_quota}'
#   which is more accurate...
# * Since we have added a little header in the listbox, we have to substract
#   one to the value gotten from the listbox line, that is the real user line.
#
# Revision 1.18  1997/09/20 17:24:02  turbo
# * When editing any of the configs, make sure we close any window left..
# * When sizing a string, if the value should be 0 (like root's uid/gid),
#   we can not do a if on it... Before calling the function, we add a dot
#   before the value, and then remove it in the size_string() function.
# * When updating the listbox, call the listbox_header() function, which
#   clears the listbox and inputs a little header at the top of the listbox...
#
# Revision 1.17  1997/09/19 03:18:02  turbo
# * When using the 'neteditor/interface', pressing `Done' should update the
#   hosts listbox with the new IP address.
# * Instead of going to the main routine in the goto_main() function (which
#   reloads the passwd/group file), update the listbox instead...
# * Better looking output when debuging...
#
# Revision 1.16  1997/08/24 02:15:38  turbo
# * Instead of having a button saying 'Add user' in the add user window, just
#   say: 'Save' instead... dfjklasjfdk...
# * Don't try to save the tcpquota, if we haven't choosen to support it...
# * If we can't find the config files, so what? Why whine about it?
# * Corrected some major buggs in the creation of directories/full paths...
#   Worked in debug mode, strangly enought...
#
# Revision 1.15  1997/09/23 22:25:15  turbo
# * When editing the host- and/or the domainname, don't forget to update the
#   button at the top of the network editor's window...
# * Fixed a little bugg in the get_list_entry() conserning the network editor.
#
# Revision 1.14  1997/09/23 13:58:17  turbo
# * Added support for the 'edit_name()' in the network editor.
# * In the DNS editor, have the main buttons in a nicer looking order...
# * Use 'yes´ or 'no' in the config files, but use '1' or '0' in the program,
#   so that the Checkbuttons etc works as they should.
# * Make sure we don't die just because we can not find the domainname file,
#   it is quite easy to figgure that out any way...
# * See if we can find out the hostname some how...
#
# Revision 1.13  1997/08/16 19:12:10  turbo
# When choosing 'Save' in the Network editor, make sure we save the hosts and
# the resolv.conf file to...
#
# Revision 1.12  1997/08/15 23:00:34  turbo
# * Added a Cancel button to the option windows.
# * When editing a user, pressing 'Done', also saves the TCP quota (after
#   saving the passwd file=.
#
# Revision 1.11  1997/08/15 11:24:05  turbo
# * Added support for the TCPQuota package in the user editor.
# * Added '-expand => yes' to all the middle main buttons, so that they will
#   resize together with the window...
#
# Revision 1.10  1997/08/13 11:51:36  turbo
# Changed all the button names to '$main_button_X', so that we can focus on
# any one button from the editors (Making sure there is no other button with
# that name).
#
# Revision 1.9  1997/08/12 09:50:38  turbo
# * Changed some buttons name.
# * Added support in the 'get_list_entry()' for the newly made NET editor GUI.
#
# Revision 1.8  1997/08/07 17:22:05  turbo
# * Moved the button 'Add domain' and 'Remove domain' from the bottom to
#   above the domain menu, makes the apparence look a little better.
# * Added the function 'dirname()', which strips the filename of a full
#   path to the file.
# * Moved the function 'find_dir()' here from the user editor, it was
#   needed by both the user editor and the dns editor.
#
# Revision 1.7  1997/08/03 17:53:16  turbo
# * Added support for the Group editor.
#   1. Can now add, remove and edit groups to...
#   2. Had to change the aparense of the program and the location of the functions
#      in the code a little to correspond to the new functions...
#
# * Changed some buggs with the '$defaults{xx}' and '$config{xx}' variables,
#   only at the top of the source, should we use '$defaults'...
#
# * Had to change the function 'goto_main()' to correspond to the new variable
#   '$config{main_func}' where you deside if you want to edit users or groups.
#
# Revision 1.6  1997/07/22 07:38:04  turbo
# Added more buttons to the 'net' function (Add).
#
# Revision 1.5  1997/04/26 21:39:25  turbo
# Added support for 'xedit-net'.
#
# Revision 1.4  1997/04/20 17:45:48  turbo
# * Fixed the edit-entry
# * Added support for remove-entry
#   (Not a very subtile solution though)
# * Found a better way to remove an entry
#
# Revision 1.3  1997/04/19 23:15:38  turbo
# Added support for add/edit dns-entry
# Added support for add dns-domain
# Fixed bugg in size_string()
#
# Revision 1.2  1997/04/07 23:43:27  turbo
# Small changes in code to support 'DNS editor'...
# Moved the get_config() to lib.
# Changed size_string(), now it can ad spaces before OR after (left/right)...
#
# Revision 1.1  1997/03/29 04:10:39  turbo
# Fixed small buggs in GUI and removed 'level' option in get_list_entry(),
# was not needed any more...
#
# Revision 1.0.0.1  1997/03/12 02:10:44  turbo
# Initial release of 'XAdmin', a administration tool for X11.
# Needs perl and perl-tk. Made by Turbo Fredriksson <turbo@tripnet.se>
#

# ----------------------
# proc main_buttons( window, window_level )
# This is the main buttons...
sub main_buttons {
    # window - What window to put the buttons in
    # level  - Window level
    #          main    - Main interface
    #          user    - Put up a user window
    #          conf    - Configure program
    #          edit    - Edit user
    #          change  - Change passwd
    #          add     - Add user
    #          dns     - Edit DNS database
    local($window, $level) = @_;
    my($button);

    printf("Calling main_buttons( $window, $level )...\n") if( $DEBUG );

    # Prepare the main button...
    $button = $window->Frame;
    $button->pack(-side   => 'bottom', 
		  -expand => 1,
		  -fill   => 'x',
		  -padx   => '.5c'
    );

    # Create the buttons. Remember, we do not nessesarily need to pack them...
    $main_button_1 = $button->Button(-underline => 0, -width => 4 );
    $main_button_2 = $button->Button(-underline => 0, -width => 4 );
    $main_button_3 = $button->Button(-underline => 0, -width => 8 );
    $main_button_4 = $button->Button(-underline => 0, -width => 8 );
    $main_button_5 = $button->Button(-underline => 0, -width => 8 );
    $main_button_6 = $button->Button(-underline => 0, -width => 8 );
    $main_button_7 = $button->Button(-underline => 0, -width => 8 );

    # Always add these...
    $main_button_1->configure(-text => 'Quit',  -command => sub{
	exit(0);
    });
    $main_button_2->configure(-text => 'Help',  -command => \&help, -state => 'disabled');
    $main_button_1->pack(-side      => 'left',  -anchor => 'w');
    $main_button_2->pack(-side      => 'right', -anchor => 'e');

    # Configure and pack the right buttons...
    if($level eq 'user') {
	$main_button_3->configure(-text => 'Lock',   -command => \&lock_user);
	$main_button_4->configure(-text => 'Unlock', -command => \&unlock_user);
	$main_button_5->configure(-text => 'Add',    -command => [\&edit_user, 'new', 'add']);
	$main_button_6->configure(-text => 'Remove', -command => \&rem_user);
	$main_button_7->configure(-text => 'Edit',   -command => sub{&get_list_entry( 'user', $user_listbox)});

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_7->pack(-fill => 'both', -side => 'right', -expand => 'yes');
	$main_button_6->pack(-fill => 'both', -side => 'right', -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'add_user') {
	$main_button_3->configure(-text => 'Add user',   -command => [\&add_user, $window]);
	$main_button_4->configure(-text => 'Quotas',     -command => [\&show_quota, $user_name], -state => 'disabled');
	$main_button_5->configure(-text => 'Cancel',     -command => [$window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'edit_user') {
	$main_button_3->configure(-text => 'Done',       -command => sub{
	    # Save the passwd file...
	    save_passwd_file( $user_name, $edit_user_window, 'change');

	    if( $config{display_quota} eq 'yes' || $config{display_quota} eq 1 ) {
		save_tcp_quota(   $user_name, $tcp_quota_new );
	    }

	    goto_main();
        });
	$main_button_4->configure(-text => 'Quotas',     -command => [\&show_quota, $user_name], -state => 'disabled');
	$main_button_5->configure(-text => 'Cancel',     -command => [$edit_user_window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'edit_name' ) {
	$main_button_3->configure(-text => 'Done',       -command => sub{
	    # Update the hostname/domainname button...
	    $hostdomain_button->configure(-text => "$hostname.$domain");
	    
	    # Close the edit name window...
	    $edit_name_window->destroy;
	});
	$main_button_4->configure(-text => 'Cancel',     -command => [$edit_name_window => 'destroy']);
	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
    } elsif($level eq 'group') {
	$main_button_3->configure(-text => 'Add',        -command => [\&edit_group, 0, 'add']);
	$main_button_4->configure(-text => 'Remove',     -command => \&rem_group);
	$main_button_5->configure(-text => 'Edit',       -command => sub{get_list_entry( 'group', $group_listbox)});

	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'right', -expand => 'yes');
	$main_button_3->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'add_group') {
	$main_button_3->configure(-text => 'Done',       -command => [\&add_group, $window]);
	$main_button_4->configure(-text => 'Quotas',     -command => [\&show_quota, $group_name], -state => 'disabled');
	$main_button_5->configure(-text => 'Cancel',     -command => [$window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'edit_group') {
	$main_button_3->configure(-text => 'Done',       -command => sub{
	    # Save the passwd file...
	    save_group_file( $group_name, 'change');
        });
	$main_button_4->configure(-text => 'Quotas',     -command => [\&show_quota, $group_name], -state => 'disabled');
	$main_button_5->configure(-text => 'Cancel',     -command => [$edit_group_window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'choose_group') {
	$main_button_3->configure(-text => 'Done',       -command => [$choose_group_window => 'destroy']);
	$main_button_4->configure(-text => 'Cancel',     -command => [$choose_group_window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'choose_user') {
	$main_button_3->configure(-text => 'Done',       -command => [$choose_user_window => 'destroy']);
	$main_button_4->configure(-text => 'Cancel',     -command => [$choose_user_window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'quota') {
	$main_button_3->configure(-text => 'Done',       -command => sub{
	    # Save the quota...
	    save_quota( $user_name, $show_quota_window, 'change');
	    $show_quota_window->destroy;
        }, -state => 'disabled');
	$main_button_4->configure(-text => 'Cancel',     -command => [$show_quota_window => 'destroy']);
	$main_button_5->configure(-text => 'Edit',       -command => sub{get_list_entry( 'quota', $quota_listbox)});

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'quota2') {
	$main_button_3->configure(-text => 'Done',       -command => sub{
	    # Save the quota...
	    save_quota( $user_name, $edit_quota_window, 'change');
	    $show_quota_window->destroy;
	    $edit_quota_window->destroy;
        }, -width => 4, -state => 'disabled');
	$main_button_4->configure(-text => 'Cancel',     -command => [$edit_quota_window => 'destroy'], -width => 4);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
    } elsif($level eq 'conf') {
	$main_button_3->configure(-text => 'Use',        -command => \&goto_main);
	$main_button_4->configure(-text => 'Save',       -command => \&save_config_file);
	$main_button_5->configure(-text => 'Cancel',     -command => sub{
	    # Close the right window...
	    $edit_sizes_window->destroy   if Exists($edit_sizes_window);
	    $edit_paths_window->destroy   if Exists($edit_paths_window);
	    $edit_options_window->destroy if Exists($edit_options_window);
	    $edit_user_window->destroy    if Exists($edit_user_window);
	    $edit_group_window->destroy   if Exists($edit_group_window);
	});

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'change') {
	$main_button_3->configure(-text => 'Cancel',     -command => [$window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
    } elsif($level eq 'dns') {
	$main_button_3->configure(-text => 'New real',   -command => sub{edit_entry( $dns_listbox_1, 'add', 'real')},  -underline => 4, -width => 9);
	$main_button_4->configure(-text => 'Save',       -command => \&save_dns,   -underline => 0, -width => 5);
	$main_button_5->configure(-text => 'New alias',  -command => sub{edit_entry( $dns_listbox_2, 'add', 'alias')}, -underline => 4, -width => 9);

	$main_button_3->pack(-fill => 'both', -side => 'left',  -expand => 'yes');   # New real
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');   # New alias
	$main_button_5->pack(-fill => 'both', -side => 'right', -expand => 'yes');  # Save
    } elsif($level eq 'dns_edit_real') {
	$main_button_3->configure(-text => 'Cancel', -width => 4, -command => [$dns_edit_window => 'destroy']);
	$main_button_4->configure(-text => 'Remove', -width => 5, -command => sub{
	    # Find the choosen line...
	    $line = $dns_listbox_1->index('active');

	    # Rearange the entries...
	    for( $i = $line; $i < $real_entries; $i++ ) {
		if( $real_entry{$i} ) {
		    $real_entry{$i}   = $real_entry{$i+1};
		}
	    }
	    $real_entry{$i} = "";
	    $real_entries--;

	    # Update the listbox...
	    listbox_dns( $dns_listbox_1, 'real' );

	    # Close the edit/add window...
	    $dns_edit_window->destroy;
	});
	$main_button_5->configure(-text => 'Done',   -width => 3, -command => sub{
	    # Find the choosen line...
	    $line = $dns_listbox_1->index('active');

	    # Put together the changed real entry...
	    $real_entry{$line} = "$source\:$destination";

	    # Update the listbox...
	    listbox_dns( $dns_listbox_1, 'real' );

	    # Close the edit/add window...
	    $dns_edit_window->destroy;
	});

	$main_button_3->pack(-fill => 'both', -side => 'right', -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
    } elsif($level eq 'dns_edit_alias') {
	$main_button_3->configure(-text => 'Cancel', -width => 4, -command => [$dns_edit_window => 'destroy']);
	$main_button_4->configure(-text => 'Remove', -width => 5, -command => sub{
	    # Find the choosen line...
	    $line = $dns_listbox_2->index('active');

	    # Rearange the entries...
	    for( $i = $line; $i < $alias_entries; $i++ ) {
		if( $alias_entry{$i} ) {
		    $alias_entry{$i}   = $alias_entry{$i+1};
		}
	    }
	    $alias_entry{$i} = "";
	    $alias_entries--;

	    # Update the listbox...
	    listbox_dns( $dns_listbox_2, 'alias' );

	    # Close the edit/add window...
	    $dns_edit_window->destroy;
	});
	$main_button_5->configure(-text => 'Done',   -width => 3, -command => sub{
	    # Put together the changed alias entry...
	    $line = $dns_listbox_2->index('active');

	    # Put together the changed real entry...
	    $alias_entry{$line} = "$source\:$destination";

	    # Update the listbox...
	    listbox_dns( $dns_listbox_2, 'alias' );

	    # Close the edit/add window...
	    $dns_edit_window->destroy;
	});

	$main_button_3->pack(-fill => 'both', -side => 'right', -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left', -expand => 'yes');
	$main_button_5->pack(-fill => 'both', -side => 'left',  -expand => 'yes');
    } elsif($level eq 'dns_add_real') {
	$main_button_3->configure(-text => 'Cancel', -width => 4, -command => [$dns_edit_window => 'destroy']);
	$main_button_4->configure(-text => 'Done',   -width => 3, -command => sub{
	    # Put together the new entry...
	    $real_entry{$real_entries} = "$source\:$destination";
	    $real_entries++;

	    # Clear the listbox...
	    $dns_listbox_1->delete(0, 'end');

	    # Read in the entries again...
	    listbox_dns( $dns_listbox_1, 'real' );

	    # Close the edit/add window...
	    $dns_edit_window->destroy;
	});

	$main_button_3->pack(-fill => 'both', -side => 'right');
	$main_button_4->pack(-fill => 'both', -side => 'left');
    } elsif($level eq 'dns_add_alias') {
	$main_button_3->configure(-text => 'Cancel', -width => 4, -command => [$dns_edit_window => 'destroy']);
	$main_button_4->configure(-text => 'Done',   -width => 3, -command => sub{
	    # Put together the new entry...
	    $alias_entry{$alias_entries} = "$source:$destination";
	    $alias_entries++;

	    # Clear the listbox...
	    $dns_listbox_2->delete(0, 'end');

	    # Read in the entries again...
	    listbox_dns( $dns_listbox_2, 'alias' );

	    # Close the edit/add window...
	    $dns_edit_window->destroy;
	});

	$main_button_3->pack(-fill => 'both', -side => 'right');
	$main_button_4->pack(-fill => 'both', -side => 'left');
    } elsif($level eq 'net') {
	$main_button_3->configure(-text => 'Save',       -command => sub{
	    save_network();
	    save_hosts();
	    save_resolv();
	    save_domain();
	    save_hostname();
	}, -width => 35);

	$main_button_3->pack(-fill => 'both', -side => 'top', -expand => 'yes');
    } elsif($level eq 'date') {
	$main_button_3->configure(-text => 'Set date', -command => sub{
	    set_date();
	});
	$main_button_4->configure(-text => 'Set zone', -command => sub{
	    set_zone();
	});

	$main_button_3->pack(-fill => 'both', -side => 'left', -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'right', -expand => 'yes');
    } elsif($level eq 'add_host' ) {
	$main_button_3->configure(-text => 'Cancel', -width => 4, -command => [$add_host_window => 'destroy']);
	$main_button_4->configure(-text => 'Done',   -width => 3, -command => sub{
	    my($temp);

	    $temp  = size_string( 'right',   $ip_address{$host_no}, 18);
	    $temp .= size_string( 'right',   $hostname{$host_no},   35);
	    $temp .= size_string( 'right',   $hostalias{$host_no},  20);

	    $hosts_listbox->insert('end',    $temp);

	    $host_no = "";
	    $hosts++;

	    $add_host_window->destroy;
	});

	$main_button_3->pack(-fill => 'both', -side => 'right');
	$main_button_4->pack(-fill => 'both', -side => 'left');
    } elsif($level eq 'edit_host' ) {
	$main_button_3->configure(-text => 'Cancel', -width => 4, -command => [$add_host_window => 'destroy']);
	$main_button_4->configure(-text => 'Done',   -width => 3, -command => sub{
	    my($temp);

	    $temp  = size_string( 'right',   $ip_address{$host_no}, 18);
	    $temp .= size_string( 'right',   $hostname{$host_no},   35);
	    $temp .= size_string( 'right',   $hostalias{$host_no},  20);

	    $hosts_listbox->delete($host_no, $host_no);
	    $hosts_listbox->insert($host_no, $temp);

	    $hosts++;

	    $add_host_window->destroy;
	});

	$main_button_3->pack(-fill => 'both', -side => 'right');
	$main_button_4->pack(-fill => 'both', -side => 'left');
    } elsif($level eq 'net_add') {
	$main_button_3->configure(-text => 'Done',       -command => sub{

	    if( $interface_name{$interface_no} ) {
		$interface_listbox->insert('end', "interface $interface_name{$interface_no} ($interface{$interface_no})");
	    } else {
		$interface_listbox->insert('end', "interface $interface{$interface_no}");
	    }

	    # Count up the total number of interfaces...
	    $interfaces++;

	    $add_interface_window->destroy;

	    edit_interface('conf');
	});
	$main_button_4->configure(-text => 'Cancel',     -command => [$add_interface_window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left', -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left', -expand => 'yes');
    } elsif($level eq 'net_edit' ) {
	$main_button_3->configure(-text => 'Done',       -command => sub{
	    my($i, $REMEMBER, $temp);

	    if( $interface_addr{$interface_no} ) {
		# Make sure we remember only uniq interfaces...
		$i = 0; $REMEMBER = 1;
		while( $ip_address{$i} ) {
		    if( $ip_address{$i} eq $interface_addr{$interface_no} ) {
			$REMEMBER = 0;
		    }

		    $i++;
		}

		if( $REMEMBER ) {
		    $ip_address{$interface_no} = $interface_addr{$interface_no};
		    $hostname{$interface_no}   = $interface_host{$interface_no};

		    # Get at least one alias, the hostname...
		    $hostalias{$interface_no}  = (split('\.', $interface_host{$interface_no}))[0];

		    # Add this interface address to the hosts list box...
		    $temp  = size_string( 'right', $interface_addr{$interface_no}, 18);
		    $temp .= size_string( 'right', $interface_host{$interface_no}, 35);
		    $temp .= size_string( 'right', $hostalias{$interface_no}, 20);

		    $hosts_listbox->insert('end',    $temp);
		    $hosts++;
		}
	    }

	    # Remove the edit interface window...
	    $edit_interface_window->destroy;
	});
	$main_button_4->configure(-text => 'Cancel',     -command => [$edit_interface_window => 'destroy']);

	$main_button_3->pack(-fill => 'both', -side => 'left', -expand => 'yes');
	$main_button_4->pack(-fill => 'both', -side => 'left', -expand => 'yes');
    }
}

# ----------------------
# proc get_list_entry( type, listview )
# Get the line from the listview...
sub get_list_entry {
    # type  - What to get
    #         user
    #         group
    #         quota
    # list  - Which listview should we check
    local($type, $list) = @_;
    my(@temp);

    printf("Calling get_list_entry($type, $list)...\n") if( $DEBUG );

    # Just make sure we have choosen a user...
    if(! $list ) {
	printf("ERROR: Nothing selected...\n");
	return;
    }

    # Get the whole line...
    $entry_number = $list->index('active');
    $entry_number--;

    printf("  Listbox entry number: $entry_number\n") if( $DEBUG );
    if( ($type eq 'secondary_group_add') || ($type eq 'secondary_group_rem') ||
        ($type eq 'primary_group')       || ($type eq 'group_member')        ||
        ($type eq 'group')               || ($type eq 'interface')           ){

	$entry_number++;
    } else {
	# Just double check that we have a valid number...
	if( $entry_number < 0 ) {
	    my($cancel, $dialog) = ('Oopps', '');

	    # Nope, this is the first (the header), create a error dialog...
	    $dialog = $main_window->Dialog(-text           => 'You have to choose a user or group to edit...',
					   -bitmap         => 'error',
					   -default_button => $cancel,
					   -buttons        => [$cancel]
					   );
	    $dialog->Show;

	    return;
	}
    }

    # We wants to edit a user/group...
    if( $type eq 'user' ) {
	# Edit a user...
	edit_user($entry_number, 'edit');
    } elsif( $type eq 'group' ) {
	# Remove a group...
	edit_group($entry_number, 'edit');
    } elsif( $type eq 'quota' ) {
	# Edit quota...
	edit_quota( $entry_number );
    } elsif( $type eq 'interface' ) {
	$interface_no = $entry_number;
	edit_interface( 'conf' );
    } elsif( $type eq 'secondary_group_add' ) {
	@temp = split(':', $group_line{$entry_number});

	$secondary_groups{$secondary} = "$user_name:$temp[0]";
	printf("  New secondary group: $secondary_groups{$secondary}\n") if( $DEBUG );

	$secondary++;
	$add_to_group = 1;

	$secondary_groups_listbox->insert('end', $temp[0]);

	# Close the window...
	$choose_group_window->destroy;
    } elsif( $type eq 'secondary_group_rem' ) {
	$rem_groups{$rem_from_group} = "$secondary_groups{$entry_number}";
	printf("  Rem secondary group: $rem_groups{$rem_from_group}\n") if( $DEBUG );

	$secondary++;
	$rem_from_group++;

	$secondary_groups_listbox->delete('active', 'active');
    } elsif( $type eq 'primary_group' ) {
	@temp = split(':', $group_line{$entry_number});

	$primary_group = $temp[0];

	# Close the window...
	$choose_group_window->destroy;
    } elsif( $type eq 'group_member' ) {
	@temp = split(':', $passwd_line{$entry_number});

	if( $group_members ) {
	    $group_members .= ",$temp[0]";
	} else {
	    $group_members  = $temp[0];
	}

	# Close the window...
	$choose_user_window->destroy;
	undef $choose_user_window;
    }
}

# ----------------------
# The procedure below inserts text into a given text widget and applies
# one or more tags to that text.  The arguments are:
# proc inswt( window, text, args )
sub inswt {
    # window   - Window in which to insert
    # text     - Text to insert (it's inserted at the "insert" mark)
    # args     - One or more tags to apply to text.  If this is empty then all
    #            tags are removed from the text.
    my($window, $text, @args) = @_;
    my($tag, $i, $start);

    $start = $window->index('insert');
    $window->insert('insert', $text);
    foreach $tag ($window->tag('names', $start)) {
        $window->tag('remove', $tag, $start, 'insert');
    }
    foreach $i (@args) {
        $window->tag('add', $i, $start, 'insert');
    }

} # end inswt()

# ----------------------
# Make sure a string is of exact length...
# proc size_string( side, text, max_length )
sub size_string {
    local($side, $string, $max_length) = @_;
    my( $length, $new_string, $strlen, $temp, $i ) = "";

    $new_string = " ";

    if(! $string) {
	if( defined($string) ) {
	    # It _IS_ defined, but if says it's not since it's zero (0)...
	    # Sometimes perl can be very annoying...
	    $string = 0;
	    $length =  $max_length - 1;
	} else {
	    $string =  "";
	    $length =  $max_length;
	}
    } else {
	# If the first character is a dot, remove that...
	$string     =~ s/^\.//;
	$strlen     =  length($string);
	$length     =  $max_length - $strlen;
    }

    if( $side eq 'right' ) {
	$new_string = $string;

	for( $i = 1; $i < $length; $i++ ) {
	    $new_string .= " ";
	}
    } elsif( $side eq 'left' ) {
	for( $i = 1; $i < $length; $i++ ) {
	    $new_string .= " ";
	}

	$new_string .= $string;
    }

    return($new_string);
} # end size_string()

# ----------------------
# Goto main...
# proc goto_main( void )
sub goto_main {
    # Close the right window...
    $edit_sizes_window->destroy   if Exists($edit_sizes_window);
    $edit_paths_window->destroy   if Exists($edit_paths_window);
    $edit_options_window->destroy if Exists($edit_options_window);
    $edit_user_window->destroy    if Exists($edit_user_window);
    $edit_group_window->destroy   if Exists($edit_group_window);

    if( $config{main_func} eq 'users' ) {
	# Insert the header...
	listbox_header($user_listbox);

	# Sort the passwd list...
	sort_list('passwd');

	# Read in the user/group data to the text widget...
	listbox_user($user_listbox)
    } elsif( $config{main_func} eq 'groups' ) {
	main_groups();
    } elsif( $config{main_func} eq 'quotas' ) {
	main_quotas();
    }
}

# ----------------------
# Bind emacs keys to input widget...
# proc emacs_bindings( window )
sub emacs_bindnings {
    local($window) = @_;

    # Set up editing bindings
    $window->bind('<Meta-d>'    => "%W delete insert {insert wordend}");
    $window->bind('<Meta-p>'    => "%W mark set insert 1.0");
    $window->bind('<Meta-n>'    => "%W mark set insert end");
#   $window->bind('<Delete>'    => [bind Text <BackSpace>]);
    $window->bind('<3>'         => "%W insert insert \[selection get\]; %W yview -pickplace insert");
    $window->bind('<Control-y>' => "%W insert insert \[selection get\]; %W yview -pickplace insert");

    # Set up editing bindings
#   $window->bind('<Delete>'    => [bind Entry <BackSpace>]);
    $window->bind('<3>'         => "%W insert insert \[selection get\]");
    $window->bind('<Control-y>' => "%W insert insert \[selection get\]");
}

# ----------------------
# proc get_config( %default )
# Get the configs from the config file...
sub get_config {
    local(%default) = @_;

    printf("Calling get_config(<defaults from top of source>)...\n") if( $DEBUG );

    my($current_line, %config);

    # First fill in default values incase we could not find a value...
    foreach $element (sort keys %default) {
	if(! $config{$element} ) {
	    # Make sure it isn't just 0...
	    if(! $config{$element} ) {
		$config{$element} = $default{$element};

		# Do some converting: yes to 1, no to 0...
		if($config{$element} eq 'no') {
		    $config{$element} = '0';
		} elsif($config{$element} eq 'yes') {
		    $config{$element} = '1';
		}
	    }
	}
    }

    # if there's not a config file, return the default.
    $file_opened = 0;
    if(! -f "$HOME/.$CONFIG_FILE" ) {
	#printf("WARNING: Couldn't find the config-file, \`$HOME/.$CONFIG_FILE\'...\n");

	if(! -f "$CONFIG_DIR/$CONFIG_FILE" ) {
	    # Tell user we could not find a config file...
	    #printf("WARNING: Couldn't find the config-file, \`$CONFIG_DIR/$CONFIG_FILE\', using defaults\n");
	} else {
	    open (CONF, "$CONFIG_DIR/$CONFIG_FILE") || die "  open: $!";
	    printf("  Using file: '$CONFIG_DIR/$CONFIG_FILE'...\n") if( $DEBUG );
	    $file_opened = 1;
	}
    } else {
	open (CONF, "$HOME/.$CONFIG_FILE") || die "  open: $!";
	printf("  Using file: '$HOME/.$CONFIG_FILE'...\n") if( $DEBUG );
	$file_opened = 1;
    }

    if($file_opened == 1) {
	while(! eof(CONF) ) {
	    $current_line = <CONF>;
	    chop $current_line;

	    $current_line =~ s/\"//g;    # get rid of: "
	    $current_line =~ s/\'//g;	 # get rid of: '

	    # Convert line to lower case...
	    $current_line = lc($current_line);

	    foreach $element (sort keys %default) {
		if( $current_line =~ /^$element/ ) {
		    @line = split('=', $current_line);
		    $word = substr($line[1], 1);

		    # Do some converting: yes to 1, no to 0...
		    if($word eq 'no') {
			$config{$element} = 0;
		    } elsif($word eq 'yes') {
			$config{$element} = 1;
		    } else {
			$config{$element} = $word;
		    }
		}
	    }
	}
	close( CONF );
    }

    # Open the file with the default domain name...
    $file_opened = 0;
    unless( open(DOMAIN, $config{domainname}) ) {
	# Can't open '/etc/domainname'...
	unless( open( DOMAIN, "/bin/domainname |") ) {
	    # Can't open '/bin/domainname'...
	    unless( open( DOMAIN, "/bin/dnsdomainname |") ) {
		# Can't open '/bin/dnsdomainname'...
		printf("  Just can't figure out the domainname, setting it to 'unset'!!!\n");

		$domain = "unset";
	    } else {
		$file_opened = 1;
	    }
	} else {
	    $file_opened = 1;
	}
    } else {
	$file_opened = 1;
    }

    if($file_opened) {
	# Get the first line (the domain name)...
	$domain = <DOMAIN>;
	chop( $domain );

	# Close the domain name file...
	close(DOMAIN);
    }

    # Some debug output, perhaps?
    printf("  Found the domainname    : $domain\n") if( $DEBUG );

    # Find the hostname...
    if( open(HOST, "/bin/hostname |") ) {
	$hostname = <HOST>;
	chop( $hostname );
	close(HOST);
    } else {
	printf("  Could not find the hostname, setting it to 'unset'...\n");
	$hostname = "unset";
    }

    if( $DEBUG ) {
	foreach $element (sort keys %config) {
	    printf("    %-22s: '%s'\n", $element, $config{$element});
	}

	printf("    Domain name           : $domain\n");
    }

    return %config;
}

# ----------------------
# proc get_config_tcp( configfile, programname )
# Get the configs from the config file...
sub get_config_tcp {
    local($configfile,$prog) = @_;
    my($temp);

    open(CF,$configfile) || die "Can't open $configfile...\n";
#    print "Reading $configfile configfile\n" if $DEBUG;
    config: while(! eof(CF) ) {
	$temp = <CF>;
	chop($temp);

	if( $temp =~ /^[\w\.]*=/ ) {
	    if( $temp = /^\w*\.\w*=/ ) {
		
		# local config for this prog.  remote proceding string.
		if ( $temp =~ /^$prog/ ) {
		    $temp =~ s/^($prog)\.//;
		} else {
		    # local config  not to this program..
		    next config;
		}
	    }
	    ($name,$var)=split('=', $temp);
#	    printf("$name = $var\n") if $DEBUG;
	    $cf{$name} = $var;
	}
    }
    close(CF);
}

# ----------------------
# proc create_leading_dirs( path, umask )
# Create full directory structure...
sub create_leading_dirs {
    local( $path, $umask ) = @_;
    my( @temp, $tmp, $attempt, $new_dir, $done, $old_umask );

    $old_umask = umask( 000 );

    # Chop off any trailing slash...
    if( $path =~ m%/$% ) {
	chop( $path );
    }

    # Split up the path...
    @temp = split( '\/', $path );

    $done = "";

    # Create the directory one by one...
    while( @temp ) {
	# Get the next dir from top...
	$attempt = shift( @temp );
	if( $attempt ) {
	    if( $done eq '' ) {
		$tmp = "$attempt";
	    } else {
		$tmp = "$done/$attempt";
	    }

	    # Just incase we have a leading slash...
	    if( ($path =~ /^\//) && ($tmp !~ /^\//) ) {
		$new_dir  = "/" . $tmp;
	    } else {
		$new_dir = $tmp;
	    }

	    if(! -d $new_dir ) {
		# Create dir...
#		printf("  Creating:                 $new_dir\n") if( $DEBUG );
		mkdir($new_dir, $umask) || die "Could not create dir         $new_dir, $!";
	    }

	    # See if we could make the new directory...
	    if( -d $new_dir ) {
		$done = $new_dir;
	    }
	}
    }

    # Restore the umask...
    umask( $old_umask );
}

# ----------------------
# proc wanted
# This is the function that is called by the 'find()' function
# It stores each file and dir in an array...
#
sub wanted {
    push(@FILES, $File::Find::name);
}

1;
