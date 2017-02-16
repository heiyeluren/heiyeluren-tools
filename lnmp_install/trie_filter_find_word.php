<?php
//设定词库路径
define("ILLEGAL_DICT_PATH"		, "./blackword.dic");

//准备需要检测的文本
$text = '感冒，总体上分为普通感冒和流行性感冒，在这里先讨论普通感冒。普通感冒，祖国医学称"伤风"，是由多种病毒引起的一种呼吸道常见病，其中30%-50%是由某种血清型的鼻病毒引起，普通感冒虽多发于初冬，但任何季节，如春天，夏天也可发生，不同季节的感冒的致病病毒并非完全一样。流行性感冒，是由流感病毒引起的急性呼吸道传染病。病毒存在于病人的呼吸道中，在病人咳嗽，打喷嚏时经飞沫传染给别人。流感的传染性很强，由于这种病毒容易变异，即使是患过流感的人，当下次再遇上流感流行，他仍然会感染';

//进行检测
$tp = trie_filter_load(ILLEGAL_DICT_PATH);
$arrRet = trie_filter_search($tp, $text);		//检测是否包含敏感词，检测到一个及返回
$arrRet = trie_filter_search_all($tp, $text);	//把所有敏感词都返回


//输出检测结果
echo "原始文本：$str\n";
echo "检测到敏感词及位置："
foreach ($res as $k => $v) {
    echo $k."=>{$v[0]}-{$v[1]}-".substr($str, $v[0], $v[1])."\n";
}

//释放资源
trie_filter_free($tp);

?>
