<?php
//定义敏感词来源和目标生成词库
define("ILLEGAL_WORD_LIST_PATH"	, "./dict.txt");	   //注意必须一行一个敏感词的txt文件，注意编码，建议UTF8
define("ILLEGAL_DICT_PATH"		, "./blackword.dic");

//加载来源词
ini_set('memory_limit', '512M');
$arrWord = file(ILLEGAL_WORD_LIST_PATH);

//构建词库后保存
$tp = trie_filter_new();
foreach ($arrWord as $k => $v) {
    trie_filter_store($tp, $v);
}
trie_filter_save($tp, ILLEGAL_DICT_PATH);
trie_filter_free($tp);

?>
