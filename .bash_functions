# . ~/.bash_functions
#
# @author - manj@cs.stanford.edu
#
#

# colorize maven output
function mvncolor() {
    MAVEN=`which mvn`
    $MAVEN $@ | sed -e "s/\(\[INFO\]\ \-.*\)/[36;01m\1[m/g" \
        -e "s/\(\[INFO\]\ >>> .*\)/[32;01m\1[m/g"           \
        -e "s/\(\[INFO\]\ <<< .*\)/[32;01m\1[m/g"           \
        -e "s/\(\[INFO\]\ Building .*\)/[36;01m\1[m/g"      \
        -e "s/\(\[INFO\]\ \[.*\)/01m\1[m/g"                 \
        -e "s/\(\[INFO\]\ BUILD SUCCESS.*\)/[01;32m\1[m/g"  \
        -e "s/\(\[INFO\]\ BUILD FAILURE.*\)/[01;31m\1[m/g"  \
        -e "s/\(\[WARNING\].*\)/[01;33m\1[m/g"              \
        -e "s/\(\[ERROR\].*\)/[01;31m\1[m/g"                \
        -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/[32mTests run: \1[m, Failures: [01;31m\2[m, Errors: [01;31m\3[m, Skipped: [01;33m\4[m/g"
}

# human readable du reverse sorted by size
function duf() {
    DU=`which du`
    PERL=`which perl`
    $DU -sk "$@"    |                                           \
        sort -nr    |                                           \
        $PERL -ne '
            ($s, $f) = split(/\t/, $_, 2);
            for (qw(K M G T)) {
                if ($s < 1024) {
                    $x = ($s < 10 ? "%.1f" : "%3d");
                    printf("$x$_\t%s",$s,$f);
                    last;
                };
                $s /= 1024;
            }'
}
