if (!defined &_SYS_CDEFS_H) {
    eval 'sub _SYS_CDEFS_H () {1;}' unless defined(&_SYS_CDEFS_H);
    require 'features.ph';
    if (defined &__GNUC__) {
	eval 'sub __P {
	    local($args) = @_;
	    eval "$args";
	}' unless defined(&__P);
	eval 'sub __DOTS () {, ...;}' unless defined(&__DOTS);
    }
    else {
	eval 'sub __inline () {1;}' unless defined(&__inline);
	if ((defined ( &__STDC__) & (defined(&__STDC__) ? &__STDC__ : 0)) || defined ( &__cplusplus)) {
	    eval 'sub __P {
	        local($args) = @_;
	        eval "$args";
	    }' unless defined(&__P);
	    eval 'sub __const () { &const;}' unless defined(&__const);
	    eval 'sub __signed () { &signed;}' unless defined(&__signed);
	    eval 'sub __volatile () { &volatile;}' unless defined(&__volatile);
	    eval 'sub __DOTS () {, ...;}' unless defined(&__DOTS);
	}
	else {
	    eval 'sub __P {
	        local($args) = @_;
	        eval "()";
	    }' unless defined(&__P);
	    eval 'sub __const () {1;}' unless defined(&__const);
	    eval 'sub __signed () {1;}' unless defined(&__signed);
	    eval 'sub __volatile () {1;}' unless defined(&__volatile);
	    eval 'sub __DOTS () {1;}' unless defined(&__DOTS);
	}
    }
    if (defined ( &__STDC__) & (defined(&__STDC__) ? &__STDC__ : 0)) {
	eval 'sub __CONCAT {
	    local($x,$y) = @_;
	    eval "$x  $y";
	}' unless defined(&__CONCAT);
	eval 'sub __STRING {
	    local($x) = @_;
	    eval "$x";
	}' unless defined(&__STRING);
	eval 'sub __ptr_t () { &void *;}' unless defined(&__ptr_t);
	eval 'sub __long_double_t () {\'long double\';}' unless defined(&__long_double_t);
    }
    else {
	eval 'sub __CONCAT {
	    local($x,$y) = @_;
	    eval " &xy";
	}' unless defined(&__CONCAT);
	eval 'sub __STRING {
	    local($x) = @_;
	    eval "\\"x\\"";
	}' unless defined(&__STRING);
	eval 'sub __ptr_t () {\'char\' *;}' unless defined(&__ptr_t);
	eval 'sub __long_double_t () {\'long double\';}' unless defined(&__long_double_t);
	if (defined &__USE_BSD) {
	    eval 'sub const () { &__const;}' unless defined(&const);
	    eval 'sub signed () { &__signed;}' unless defined(&signed);
	    eval 'sub volatile () { &__volatile;}' unless defined(&volatile);
	}
    }
    if (defined &__cplusplus) {
	eval 'sub __BEGIN_DECLS () { &extern "C" {;}' unless defined(&__BEGIN_DECLS);
	eval 'sub __END_DECLS () {};}' unless defined(&__END_DECLS);
    }
    else {
	eval 'sub __BEGIN_DECLS () {1;}' unless defined(&__BEGIN_DECLS);
	eval 'sub __END_DECLS () {1;}' unless defined(&__END_DECLS);
    }
    if (!defined ( &__GNUC__) || (defined(&__GNUC__) ? &__GNUC__ : 0) < 2) {
	eval 'sub __attribute__ {
	    local($xyz) = @_;
	    eval "";
	}' unless defined(&__attribute__);
    }
}
1;
