# -*- coding: utf-8 -*-

# 第1引数に年度、第2引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[1] == "a" then
  period="前期"
elsif ARGV[1] == "b" then
  period="後期"
end

w = open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/ssl/index.php","w")
w.print("
<?php
/* セッションを作成 */
session_start();
?>

<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">
<html lang=\"ja\">
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"../r.css\">
<title>調査解析班#{period}授業評価アンケート</title>
</head>

<body>
<div id=\"container\">
<div id=\"main\"><?php
/*共通設定ファイルの読み込み*/
include(\"../global.php\");
title();


/*環境関数REMOTE_USERを取得*/
$userid = escape_string(getenv(\"REMOTE_USER\"));
if($userid == NULL){
	echo \"REMOTE_USER error\";
}
/* セッションに保存 */

session_destroy();
$_SESSION[\"s_userid\"] = $userid;



/* PostgreSQL サーバに接続 */
$con = m_connect();

/*SQL用にちょっと変換*/
$sql_userid = escape_string(getenv(\"REMOTE_USER\"));

/*学籍番号の頭文字を取得*/
$judge = substr(getenv(\"REMOTE_USER\"), 0, 1);

echo \"<h2 class=\\\"paragraph\\\">\".getenv(\"REMOTE_USER\").\"さんのアンケートページ</h2>\\n\";

echo \"<p><a href=\\\"\";
/* 学部生/留学生 なら addclass.php, 大学院生なら addclass_k.php */
if ($judge == 'e' || $judge == 'f') {
	echo \"./addclass.php\";
} elseif ($judge == 'k') {
	echo \"./addclass_k.php\";
}
echo \"\\\">[科目の追加・削除]</a></p>\";

/* オープンキャンパス用 */
//echo \"<p><a href=\\\"addclass.php\\\">[科目の追加・削除]</a></p>\";


/*設定済み科目のチェック*/
$query = \"select * from addclass where id = \".$userid.\";\";

/* 検索を実行 */
$rs = m_query($con, $query, \"検索に失敗しました。\");

/* 検索件数 */
$maxrows = pg_num_rows($rs);

/*まだ科目設定していない人にメッセージ*/
if( $maxrows == 0 ) {
	echo \"<p>#{ARGV[0]}年度#{period}に受講している科目を登録してください。</p>\";
}else{

	/*設定した科目のアンケートフォームへのリンクを表示*/
	echo \"<p>各授業科目のアンケートフォームです。<br>\";
	echo \"リンクをクリックして、該当科目の授業評価を行ってください。</p>\";


	$sql=\"select * from classname;\";
	$rs2 = m_query($con, $sql, \"検索に失敗しました。\");
	$rows=pg_num_rows($rs2);
	for($i=0; $i<$rows; $i++){
		$data=pg_fetch_array($rs2,$i,PGSQL_ASSOC);
		$table[$i]=$data[table_name];
		$class[$data[table_name]]=$data[class_name];
		$prac[$data[table_name]]=$data[prac];
		$touroku[$data[table_name]]=$data[touroku];
	}
	$rowdata = pg_fetch_array($rs, 0, PGSQL_ASSOC);
	$i=0;
	foreach($table as $val){
		if($rowdata[$val]==1){
			$tclass[$i]=$val;
			$i++;
		}
	}

	// 座学系
	echo \"<table border=\\\"1\\\" cellspacing=\\\"0\\\" cellpadding=\\\"5\\\" class=\\\"kamoku leftspace\\\">\";
	echo \"<tr><td class=\\\"index\\\">系統</td><td class=\\\"index\\\">科目名</td><td class=\\\"index\\\">回答状況</td><td class=\\\"index\\\">回答数/登録数</td>\";

	$keitou=array(\"座学系\",\"実験・実習系\",\"セミナー＆卒業研究\");
	$i=0;

	foreach($keitou as $kei){
		echo \"<tr><th width=\\\"140\\\" nowrap>\".$kei.\"</th>\";
		echo \"<td nowrap><ul>\";
		foreach($tclass as $val){
			if($prac[$val] == $i){
		        	$link=array(\"<li><A HREF=./form.php?kamoku=\".$val.\">\".$class[$val].\"</A>\\n\",\"<li><A HREF=./form.php?kamoku=\".$val.\"&ex=1>\".$class[$val].\"</A>\\n\",\"<li><A HREF=./form.php?kamoku=\".$val.\"&ex=2>\".$class[$val].\"</A>\\n\");
			  echo $link[$i];
			}
		}
		//回答済みor未回答の表示
		echo \"</ul></td>\";
		echo \"<td align=\\\"center\\\">\";
		foreach($tclass as $val){
			if($prac[$val] == $i){
				$sql=\"select * from \".$val.\" where id=\".$userid.\";\";
				$rs = m_query($con, $sql, \"失敗\");
				$check = pg_num_rows($rs);
				if($check == 1){
					echo \"<font color=\\\"#00bb00\\\">回答済み</font><br>\";
				}else{
					echo \"<font color=\\\"bb0000\\\">未回答</font><br>\";
				}
			}
		}
		//回答人数
		echo \"<td align=\\\"center\\\">\";
		foreach($tclass as $val){
			if($prac[$val] == $i){
				$query = \"select id from \".$val.\";\";
				$rs = m_query($con, $query, \"失敗\");
				$count = pg_num_rows($rs);
				echo (\"$count/\".$touroku[$val].\"<br>\");
			}
		}
		$i++;
	}
	echo \"</td></tr>\";
	echo \"</table>\";
}
?> <?php
echo \"<p><a href=\\\"logout.php\\\">ウィンドウを閉じる</a></p>\";
back2(1);
?></div>
</div>

</body>
</html>
")
w.close
