if (!defined &_LINUX_QUOTA_) {
    eval 'sub _LINUX_QUOTA_ () {1;}' unless defined(&_LINUX_QUOTA_);
    require 'linux/errno.ph';
    eval 'sub dbtob {
        local($num) = @_;
        eval "($num << 10)";
    }' unless defined(&dbtob);
    eval 'sub btodb {
        local($num) = @_;
        eval "($num >> 10)";
    }' unless defined(&btodb);
    eval 'sub fs_to_dq_blocks {
        local($num, $blksize) = @_;
        eval "((($num) * ($blksize)) /  &BLOCK_SIZE)";
    }' unless defined(&fs_to_dq_blocks);
    eval 'sub MAX_IQ_TIME () {604800;}' unless defined(&MAX_IQ_TIME);
    eval 'sub MAX_DQ_TIME () {604800;}' unless defined(&MAX_DQ_TIME);
    eval 'sub MAXQUOTAS () {2;}' unless defined(&MAXQUOTAS);
    eval 'sub USRQUOTA () {0;}' unless defined(&USRQUOTA);
    eval 'sub GRPQUOTA () {1;}' unless defined(&GRPQUOTA);
    eval 'sub INITQFNAMES () {{ "user", "group", "undefined", };;}' unless defined(&INITQFNAMES);
    eval 'sub QUOTAFILENAME () {"quota";}' unless defined(&QUOTAFILENAME);
    eval 'sub QUOTAGROUP () {"staff";}' unless defined(&QUOTAGROUP);
    eval 'sub NR_DQHASH () {43;}' unless defined(&NR_DQHASH);
    eval 'sub NR_DQUOTS () {256;}' unless defined(&NR_DQUOTS);
    eval 'sub SUBCMDMASK () {0x00ff;}' unless defined(&SUBCMDMASK);
    eval 'sub SUBCMDSHIFT () {8;}' unless defined(&SUBCMDSHIFT);
    eval 'sub QCMD {
        local($cmd, $type) = @_;
        eval "((($cmd) <<  &SUBCMDSHIFT) | (($type)   &SUBCMDMASK))";
    }' unless defined(&QCMD);
    eval 'sub Q_QUOTAON () {0x0100;}' unless defined(&Q_QUOTAON);
    eval 'sub Q_QUOTAOFF () {0x0200;}' unless defined(&Q_QUOTAOFF);
    eval 'sub Q_GETQUOTA () {0x0300;}' unless defined(&Q_GETQUOTA);
    eval 'sub Q_SETQUOTA () {0x0400;}' unless defined(&Q_SETQUOTA);
    eval 'sub Q_SETUSE () {0x0500;}' unless defined(&Q_SETUSE);
    eval 'sub Q_SYNC () {0x0600;}' unless defined(&Q_SYNC);
    eval 'sub Q_SETQLIM () {0x0700;}' unless defined(&Q_SETQLIM);
    eval 'sub Q_GETSTATS () {0x0800;}' unless defined(&Q_GETSTATS);
    eval 'sub dq_bhardlimit () { &dq_dqb. &dqb_bhardlimit;}' unless defined(&dq_bhardlimit);
    eval 'sub dq_bsoftlimit () { &dq_dqb. &dqb_bsoftlimit;}' unless defined(&dq_bsoftlimit);
    eval 'sub dq_curblocks () { &dq_dqb. &dqb_curblocks;}' unless defined(&dq_curblocks);
    eval 'sub dq_ihardlimit () { &dq_dqb. &dqb_ihardlimit;}' unless defined(&dq_ihardlimit);
    eval 'sub dq_isoftlimit () { &dq_dqb. &dqb_isoftlimit;}' unless defined(&dq_isoftlimit);
    eval 'sub dq_curinodes () { &dq_dqb. &dqb_curinodes;}' unless defined(&dq_curinodes);
    eval 'sub dq_btime () { &dq_dqb. &dqb_btime;}' unless defined(&dq_btime);
    eval 'sub dq_itime () { &dq_dqb. &dqb_itime;}' unless defined(&dq_itime);
    eval 'sub dqoff {
        local($UID) = @_;
        eval "(( &loff_t)(($UID) * $sizeof{\'struct dqblk\'}))";
    }' unless defined(&dqoff);
    if (defined &__KERNEL__) {
	require 'linux/mount.ph';
	eval 'sub MAX_QUOTA_MESSAGE () {75;}' unless defined(&MAX_QUOTA_MESSAGE);
	eval 'sub DQ_LOCKED () {0x01;}' unless defined(&DQ_LOCKED);
	eval 'sub DQ_WANT () {0x02;}' unless defined(&DQ_WANT);
	eval 'sub DQ_MOD () {0x04;}' unless defined(&DQ_MOD);
	eval 'sub DQ_BLKS () {0x10;}' unless defined(&DQ_BLKS);
	eval 'sub DQ_INODES () {0x20;}' unless defined(&DQ_INODES);
	eval 'sub DQ_FAKE () {0x40;}' unless defined(&DQ_FAKE);
	eval 'sub NODQUOT () { &NULL;}' unless defined(&NODQUOT);
	eval 'sub QUOTA_SYSCALL () {0x01;}' unless defined(&QUOTA_SYSCALL);
	eval 'sub SET_QUOTA () {0x02;}' unless defined(&SET_QUOTA);
	eval 'sub SET_USE () {0x04;}' unless defined(&SET_USE);
	eval 'sub SET_QLIMIT () {0x08;}' unless defined(&SET_QLIMIT);
	eval 'sub QUOTA_OK () {0;}' unless defined(&QUOTA_OK);
	eval 'sub NO_QUOTA () {1;}' unless defined(&NO_QUOTA);
    }
    else {
	require 'sys/cdefs.ph';
    }
}
1;
