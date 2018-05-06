define(`BACKTICK',`changequote(<,>)`dnl'
changequote`'')dnl
define(`substr',`ifelse($#,0,``$0'',dnl
$#,2,`substr($@,eval(len(`$1')-$2))',dnl
`ifelse(eval($3<=0),1,,dnl
`builtin(`substr',`$1',$2,1)`'substr(dnl
`$1',eval($2+1),eval($3-1))')')')dnl
