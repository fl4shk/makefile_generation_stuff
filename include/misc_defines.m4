define(`BACKTICK',`changequote(<,>)`dnl'
changequote`'')dnl
dnl
define(`substr',`ifelse($#,0,``$0'',dnl
$#,2,`substr($@,eval(len(`$1')-$2))',dnl
`ifelse(eval($3<=0),1,,dnl
`builtin(`substr',`$1',$2,1)`'substr(dnl
`$1',eval($2+1),eval($3-1))')')')dnl
dnl
define(`CONCAT', `'$1`'$2`')dnl
define(`CONCAT3', CONCAT(CONCAT($1,$2),$3))dnl
define(`INCR',`define(`$1',eval($1() + 1))')dnl
define(`DECR',`define(`$1',eval($1() - 1))')dnl
define(`_SET', `define(`$1[$2]', `$3')')dnl
define(`_GET', `defn(`$1[$2]')')dnl
dnl define(`_ARRINCR', _SET($1, $2, eval(`defn(`$1[$2]')' + 1)))
dnl define(`_ARRDECR', _SET($1, $2, eval(`defn(`$1[$2]')' - 1)))
define(`_ARRINCR', `define(`$1[$2]', eval(defn(`$1[$2]') + 1))')
define(`_ARRDECR', `define(`$1[$2]', eval(defn(`$1[$2]') - 1))')
