define(`_BACKTICK',`changequote(<,>)`dnl'
changequote`'')dnl
dnl
define(`substr',`ifelse($#,0,``$0'',dnl
$#,2,`substr($@,eval(len(`$1')-$2))',dnl
`ifelse(eval($3<=0),1,,dnl
`builtin(`substr',`$1',$2,1)`'substr(dnl
`$1',eval($2+1),eval($3-1))')')')dnl
dnl
define(`_CONCAT', `'$1`'$2`')dnl
define(`_CONCAT3', CONCAT(CONCAT($1,$2),$3))dnl
define(`_INCR',`define(`$1',eval($1() + 1))')dnl
define(`_DECR',`define(`$1',eval($1() - 1))')dnl
define(`_ARRSET', `define(`$1[$2]', `$3')')dnl
define(`_ARRGET', `defn(`$1[$2]')')dnl
define(`_ARRINCR', `define(`$1[$2]', eval(defn(`$1[$2]') + 1))')
define(`_ARRDECR', `define(`$1[$2]', eval(defn(`$1[$2]') - 1))')
