# ----------------------
# $Log: Makefile,v $
# Revision 1.39  1998/08/30 21:10:08  turbo
# When making a debian package, remove the etc and var directories...
#
# Revision 1.38  1998/08/30 21:04:12  turbo
# When making a debian package, remove the CVS directories...
#
# Revision 1.37  1998/08/30 20:58:27  turbo
# Replaced all occurrences of 'xadmin' with '$(PACKAGE)'...
#
# Revision 1.36  1998/08/30 20:52:23  turbo
# * When making a debian package, don't execute the 'char' target, just clean the
#   directory after rtag'ing it...
# * Add our changelog to the debian changelog.
# * Use $EDITOR when editing the changlog and the copyright...
# * Tell user to use 'dpkg-buildpackage -rsudo' instead of 'sudo build'... (debhelper).
#
# Revision 1.35  1998/08/01 06:47:36  turbo
# * Added the target 'install_pic', which installes the pictures. Called from the
#   main target 'install'...
# * Moved the creation of all the directories to a separate target, 'create_dirs'.
# * Use 'dh_make' (from dh-make/debhelper) to create the base files in a debian
#   package, instead of 'deb-make' (from debmake).
# * Copy my rules file in to the debian directory.
# * Remove all files in the 'var/yp' dir, so that we do not distribute such files
#   in the archive files...
#
# Revision 1.34  1998/08/01 03:35:31  turbo
# Instead of using $EDITOR to edit the copyright and changelog, use
# 'emacs -nw'...
#
# Revision 1.33  1998/06/20 21:29:14  turbo
# Install the libraries separately...
#
# Revision 1.32  1998/03/21 16:38:11  turbo
# * _COPY_ the dot files from the root of the source tree
#   to the debian directory, so that they (the dot files)
#   is included in the source package...
# * Added a '.menu' file that is copied to the debian dir.
#   Fixed bug #19992: xadmin: No menu entry. Contributed by
#   'Yann Dirson <ydirson@a2points.com>'.
#
# Revision 1.31  1998/03/15 02:52:27  turbo
# * X11 binaries should go to '/usr/X11R6/bin', not '/usr/bin/X11' (They are the
#   same, but lintian complains...)
# * Added the man path (/usr/X11R6/man) and added an entry to install the new
#   manual...
# * The target 'all' does not do anything, we use 'install' which calls
#   'install_{man|bin}' instead...
# * Make sure we chmod the correct file!!! (Tried to chmod LIBDIR/file, when
#   I should have chmod'ed INSLIB/file instead!! *duhhh*)
#
# Revision 1.30  1998/03/15 01:41:27  turbo
# Instead of removing one example file after the other, remove '*.ex' once!
#
# Revision 1.29  1998/03/04 16:22:26  turbo
# Make sure we remove any dot files in the root of the source directory...
#
# Revision 1.28  1998/03/04 16:20:47  turbo
# Make sure we don't forget to edit the changelog when making a Debian package.
#
# Revision 1.27  1998/02/22 00:48:19  turbo
# Non initialized variable 'PACKAGE' needed by the rtag target added...
#
# Revision 1.26  1998/02/22 00:45:51  turbo
# The rtag target (Upgrading of one version) was totaly fucked up...
#
# Revision 1.25  1998/02/15 20:47:47  turbo
# Fixed the 'rdiff' target... Should work better now...
#
# Revision 1.24  1997/10/12 21:19:02  turbo
# Dots instead of filename as progress meter when installing...
#
# Revision 1.23  1997/10/07 15:16:12  turbo
# When creating the archive, do not remove the directory, it is needed if we
# are making a Debian package...
#
# Revision 1.22  1997/09/24 16:34:11  turbo
# When creating the tar archive, remove all mine files in the 'etc/' directory,
#   and make sure we clean up the 'var/removed_dirs/'. Also remove the temp
#   directory when we are done.
#
# Revision 1.21  1997/09/20 18:32:16  turbo
# When installing, the sub binaries is not executable, fix this...
#
# Revision 1.20  1997/09/19 03:10:57  turbo
# When making a 'diff' or 'rdiff', output a unified diff, so we can use that
#   when patching...
#
# Revision 1.19  1997/08/24 02:08:53  turbo
# Fucked up the dating... No changes, just the dates in the revision header...
#
# Revision 1.18  1997/09/23 15:02:54  turbo
# When doing a 'char:', have the name 'xadmin-XXX' instead of 'xadmin_XXX'...
#
# Revision 1.17  1997/09/23 14:55:49  turbo
# When making a debian package, we do not have to edit the control file...
#
# Revision 1.16  1997/09/23 14:53:33  turbo
# We should _NOT_ distribute the passwd/shadow and group files!!
#
# Revision 1.15  1997/09/23 14:44:55  turbo
# When doing a 'make rdiff', we should not pipe it to 'less', maby we should
# output it to a file instead?
#
# Revision 1.14  1997/09/23 14:39:22  turbo
# Added the destination 'rdiff', so that we can se the differences between
# two release versions.
#
# Revision 1.13  1997/09/23 14:33:44  turbo
# * Instead of using temporary files, use variables.
# * Added the 'rtag' destination, which the 'debian' destination is using
#   instead. Taggs the whole directory tree, so that we can figgure out the
#   differences between two release versions...
#
# Revision 1.12  1997/09/23 13:29:23  turbo
# Instead of adding the content of my control file to the debian-control file,
# copy my file to debian...
#
# Revision 1.11  1997/08/07 17:15:48  turbo
# * Added the INSDIR and INSLIB. These variables differ a little from the
#   BINDIR and LIBDIR in the way that INSxxx is used to change the variables
#   in the sub-commands, and BINxxx is used to actually install the binaries.
#
#   All of this had to be made to make the creation of the Debian package
#   run smoothly.
# * Added a PREFIX_DIR, and some checks on this variable. All to clean up
#   the file a little, still not very propper though, have to learn how
#   to make a more advanced Makefile...
#
# Revision 1.10  1997/08/05 18:53:42  turbo
# * Moved some of the debian package file creation to separate files, to make
#   the Makefile a little cleaner.
# * Added the 'newversion' target, the '.version' file is uppgraded automaticly
#   when making a debian package.
#
# Revision 1.9  1997/08/05 04:23:14  turbo
# * Changed the 'char' target, now copies the whole source tree to '/tmp',
#   where it removes the 'CVS' directories, which should not be distributed
#   in a source package.
# * Made the 'debian' target. Creates a debian package of the source code tree.
#   Creates the important files automaticly. Uses the modified 'char' target
#   to copy the files to '/tmp', where it is safe from the real tree...
#
# Revision 1.8  1997/08/03 00:39:54  turbo
# Added check for perl binary. Changes the first (execute) line apropriatly.
#
# Revision 1.7  1997/08/02 17:18:26  turbo
# * Added the 'diff' target.
# * Added the creation of the config dir in /etc if installing.
# * Added the removal of the config dir in /etc if uninstalling.
#
# Revision 1.6  1997/08/02 16:15:44  turbo
# Changed the target 'uninstall' a little, it did not remove the subdirectory
#   $(LIBDIR)/bin before.
#
# Revision 1.5  1997/08/02 16:07:25  turbo
# Added a install/uninstall target. Changes the binaries with 'sed'
#   appropriatly (variables etc)...
#
# Revision 1.4  1997/04/26 22:01:03  turbo
# When clean'ing, remove *.orig (leftovers from a patch) to.
#
# Revision 1.3  1997/04/26 21:59:52  turbo
# When commit'ing, there is no need to step up one level in the directory
# tree... Just 'cvs commit .'.
#
# Revision 1.2  1997/03/29 04:08:11  turbo
# * Finaly got the 'Deactivate' and 'Reactivate' functions to work...
#   Also got the kreation of the home directory to work... (FINALY!!! :)
# * Cleaned up the GUI and fixed some small buggs, and added '-tearoff => 0'
#   to avoid the possibility to 'tearoff' a yes/no menu...
# * Added 'Edit quota for user' support.
#
# Revision 1.1  1997/03/12 02:21:40  turbo
# Small changes in the Makefile, added 'update:' option...
#
# Revision 1.0.0.1  1997/03/12 02:10:44  turbo
# Initial release of 'XAdmin', a administration tool for X11.
# Needs perl and perl-tk. Made by Turbo Fredriksson <turbo@tripnet.se>
#

PACKAGE=xadmin
PREFIX_DIR=/usr

# This variable is just here to make the
# Debian package creation happy, messes
# the whole makefile up.. yikes, please
# ignore...
DESTDIR=
PREFIX_DIR=$(DESTDIR)/usr

ifdef DESTDIR
# We should install in '/usr'
BINDIR=/usr/X11R6/bin
LIBDIR=/usr/lib/$(PACKAGE)
MANDIR=/usr/X11R6/man

INSBIN=$(DESTDIR)/usr/X11R6/bin
INSMAN=$(DESTDIR)/usr/X11R6/man
INSLIB=$(DESTDIR)/usr/lib/$(PACKAGE)
else
# We should install in '/usr/local'
BINDIR=/usr/local/bin/X11
LIBDIR=/usr/local/lib/$(PACKAGE)
MANDIR=/usr/local/man

INSBIN=$(DESTDIR)/usr/local/bin/X11
INSLIB=$(DESTDIR)/usr/local/lib/$(PACKAGE)
INSMAN=$(DESTDIR)/usr/local/man
endif

CFGDIR=/etc/$(PACKAGE)
SRCDIR=`pwd`
PERL=`which perl`

all:

install:	create_dirs install_bin install_lib install_pic install_man

commit:		clean remove
	# Save changes done...
	cvs commit .

diff:
	# Make a unified diff over the changes from the last commit...
	cvs diff -uN .

checkout:
	# Get the changes done...
	cd ..; rm -R $(PACKAGE); cvs checkout -kkvl $(PACKAGE)

update:
	# Check if there is any changes...
	cd ..; cvs update $(PACKAGE)

create_dirs:
	@( \
	  echo "Installing in $(PREFIX_DIR)..."; \
	  echo -n "Creating directories... "; \
	  if [ ! -d $(CFGDIR) ]; then mkdir -p $(CFGDIR); fi; \
	  if [ ! -d $(INSBIN) ]; then mkdir -p $(INSBIN); fi; \
	  if [ ! -d $(INSLIB) ]; then mkdir -p $(INSLIB); fi; \
	  if [ ! -d "$(INSLIB)/bin" ]; then mkdir $(INSLIB)/bin; fi; \
	  if [ ! -d "$(INSLIB)/pics" ]; then mkdir $(INSLIB)/pics; fi; \
	  echo "done."; \
	)

install_bin:
	# Install the files in its proper place...
	@( \
	echo -n "Copying main binary...  "; \
	sed -e "s@require \"lib/$(PACKAGE).pl\"\;@require \"$(LIBDIR)/$(PACKAGE).pl\"\;@g" \
	    -e "s@\$bin_dir = \"./bin\"\;@\$bin_dir = \"$(LIBDIR)/bin\"\;@g" \
	    -e "s@/usr/bin/perl@$(PERL)@g" \
	    < $(PACKAGE) > $(INSBIN)/$(PACKAGE); \
	chmod +x $(INSBIN)/$(PACKAGE); \
	echo "done."; \
	echo -n "Copying sub binaries    "; \
	for file in `find bin -name 'xedit-*' -type f -maxdepth 1`; do \
		echo -n "."; \
		sed -e "s@\$DEBUG  = 1\;@\$DEBUG  = 0\;@g" \
		    -e "s@/usr/bin/perl@$(PERL)@g" \
		    -e "s@/usr/local/lib/$(PACKAGE)@$(LIBDIR)@g" \
		    -e "s@require \"lib/$(PACKAGE).pl\"\;@require \"$(LIBDIR)/$(PACKAGE).pl\"\;@g" \
		    < $$file > $(INSLIB)/$$file; \
		chmod 755 $(INSLIB)/$$file; \
	done; \
	echo "done."; \
	)

install_lib:
	@( \
	echo -n "Copying libraries       "; \
	for file in "lib/$(PACKAGE).pl lib/$(PACKAGE)_save_debian.pl lib/$(PACKAGE)_save_turbo.pl"; do \
		echo -n "."; \
		cp $$file $(INSLIB); \
	done; \
	echo ""; \
	)

install_pic:
	@( \
	echo -n "Copying pictures        "; \
	for file in `find pics -name '*.xpm' -type f -maxdepth 1`; do \
		echo -n "."; \
		install -m 644 $$file $(INSLIB)/pics; \
	done; \
	echo ""; \
	)

install_man:
	@( \
	  if [ ! -d $(INSMAN)/man1 ]; then \
	    mkdir $(INSMAN)/man1; \
	  fi; \
	  for file in `find man -name '*.1x' -type f -maxdepth 1`; do \
	    cp $$file $(INSMAN)/man1; \
	  done; \
	) 

uninstall:
	# Uninstall all files installed...
	@( \
	if [ -d $(INSLIB) ]; then \
		if [ -d "$(INSLIB)/bin" ]; then \
			echo "Removing files in $(INSLIB)/bin... "; \
			for file in `find $(LIBDIR)/bin -type f -maxdepth 1`; do \
				echo "  $$file "; \
				rm $$file; \
			done; \
			cd ..; \
		fi; \
		echo "Removing files in $(INSLIB)... "; \
		for file in `find $(INSLIB) -type f -maxdepth 1`; do \
			echo "  $$file "; \
			rm $$file; \
		done; \
		cd $(SRCDIR); \
		rmdir $(INSLIB)/bin; \
		rmdir $(INSLIB); \
	fi; \
	if [ -d $(CFGDIR) ]; then \
		echo "Removing files in $(CFGDIR)... "; \
		for file in `find $(CFGDIR) -type f -maxdepth 1`; do \
			echo "  $$file "; \
			rm $$file; \
		done; \
	fi; \
	echo -n "Removing main binary... "; \
	rm $(INSBIN)/$(PACKAGE); \
	)

debian:		rtag clean
	# Make a debian package of the source tree...
	@( \
	echo "Removing crappy files... "; \
	echo "  (Errors like \`No such file or directory' is expected)"; \
	find -type d -name CVS -exec rm -Rf {} \;; \
	rm -R etc/* var/*; \
	cd ..; \
	VERSION=`cat $(PACKAGE)/.version`; \
	mv $(PACKAGE) $(PACKAGE)-$$VERSION; \
	cd $(PACKAGE)-$$VERSION; \
	cp changelog debian/changelog; \
	dh_make; \
	cd debian; \
	echo "Changing and removing some files in the debian directory..."; \
	rm *.ex; \
	cat ../.copyright >> copyright; \
	cp ../.dirs     dirs; \
	cp ../.control  control; \
	cp ../.menu     menu; \
	cp ../.rules    rules; \
	cp ../.readme   README.debian; \
	$$EDITOR changelog copyright; \
	echo; \
	echo "Now type \`cd ../$(PACKAGE)-$$VERSION && dpkg-buildpackage -rsudo' and the package will be made..."; \
	echo; \
	)

newversion:
	@( \
	VERSION=`cat .version`; \
	MAJOR=`expr substr $$VERSION 1 1`; \
	MINOR=`expr substr $$VERSION 3 1`; \
	LEVEL=`expr substr $$VERSION 5 1`; \
	LEVEL=`expr $$LEVEL + 1`; \
	echo "$$MAJOR.$$MINOR.$$LEVEL" > .version; \
	echo "We are at now version: $$MAJOR.$$MINOR.$$LEVEL"; \
	)

rtag:
	@( \
	  cp .version .version.old; \
	  VERSION=`cat .version`; \
	  MAJOR=`expr substr $$VERSION 1 1`; \
	  MINOR=`expr substr $$VERSION 3 1`; \
	  LEVEL=`expr substr $$VERSION 5 2`; \
	  NEWLV=`expr $$LEVEL + 1`; \
	  echo "$$MAJOR.$$MINOR.$$NEWLV" > .version; \
	  echo -n "We are now at version "; \
	  cat  < .version; \
	  TAG="`echo $(PACKAGE)`_`echo $$MAJOR`_`echo $$MINOR`_`echo $$LEVEL`"; \
	  echo cvs rtag: $$TAG; \
	  cvs rtag -RF $$TAG $(PACKAGE); \
	  cvs commit .version .version.old; \
	)

rdiff:
	@( \
	VERSION=`cat .version.old`; \
	MAJOR=`expr substr $$VERSION 1 1`; \
	MINOR=`expr substr $$VERSION 3 1`; \
	LEVEL=`expr substr $$VERSION 5 3`; \
	TAG="`echo $(PACKAGE)`_`echo $$MAJOR`_`echo $$MINOR`_`echo $$LEVEL`"; \
	echo "Makeing a unified diff over the changes from the last version ($$MAJOR.$$MINOR.$$LEVEL)..."; \
	cvs rdiff -ur $$TAG $(PACKAGE); \
	)

clean:		
	# Remove all crappy files that may lay around...
	find . -name '*~'       -type f -exec rm -f {} \;
	find . -name '.*~'      -type f -exec rm -f {} \;
	find . -name '#*#'      -type f -exec rm -f {} \;
	find . -name 'core'     -type f -exec rm -f {} \;
	find . -name '*strace*' -type f -exec rm -f {} \;
	find . -name '*.bak'    -type f -exec rm -f {} \;
	find . -name '*.new'    -type f -exec rm -f {} \;
	find . -name '*.orig'   -type f -exec rm -f {} \;
	find . -name '*.o'      -type f -exec rm -f {} \;

remove:
	rm -Rf home/*
	rm -Rf var/removed_dirs/*
	rm -Rf var/user_info/*

char:
	# Archive the source tree...
	@( \
	mkdir /tmp/$(PACKAGE); \
	echo -n "Copying files... "; \
	find | cpio -p /tmp/$(PACKAGE); \
	cd /tmp/$(PACKAGE); \
	echo "Removing crappy files... "; \
	echo "  (Errors like \`No such file or directory' is expected)"; \
	find -type d -name CVS -exec rm -Rf {} \;; \
	find -type f -name '*.org' -exec rm -Rf {} \;; \
	cd etc; \
	rm -Rf fstab* group* msql.acl* passwd* shadow*; \
	rm -Rf shells* init.d/network* hosts* named*; \
	rm -Rf defaultdomain* HOSTNAME* resolv*; \
	rm -Rf gshadow*; \
	cd ../home; \
	rm -Rf *; \
	cd ..; \
	rm -Rf var/named/*; \
	rm -Rf var/removed_dirs/*; \
	rm -Rf var/yp/*; \
	rm -Rf temp out* how_to_*; \
	cd ..; \
	echo -n "Creating archive... "; \
	tar czf $(PACKAGE)-`date +%y%m%d`.tgz $(PACKAGE); \
	echo "done."; \
	)

#cvs-create:	clean remove
#	cvs import -b 1.0.0 $(PACKAGE) $(PACKAGE) $(PACKAGE)
#	cd ..; rm -R $(PACKAGE); cvs checkout -kkvl $(PACKAGE)
