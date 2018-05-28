# coding: utf-8
# require 'fileutils'


# 第1引数に年度、第2引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[1] == "a" then
  period="前期"
elsif ARGV[1] == "b" then
  period="後期"
end

File.open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/process.php","w")do |file|

file.print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">
<html lang=\"ja\">

<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"./r.css\">
<title>#{ARGV[0]}年度#{period}授業評価アンケート-回答の手順</title>
</head>

<?php
include(\"./global.php\");
?>

<body>
<div id=\"container\">
<div id=\"main\">

<?php
title();
?>

<center>
<table border=\"3\">
<tr>
<td id=\"menu\">
<a href=\"./index.html\">トップページ</a>
</td>
<td id=\"menu\">
<a href=\"./purpose.php\">実施目的・注意事項</a>
</td>
<td id=\"menu\">
<a href=\"./subjects.php\">対象科目</a>
</td>
<td id=\"menu\">
<a href=\"./process.php\">回答の手順</a>
</td>
<td id=\"menu\">
<a href=\"./enq.php\">設問一覧</a>
</td>
<td id=\"menu\">
<a href=\"./result/output.php\">現在の回答状況</a>
</td>
</tr>
</table>
</center>

<h2 class=\"paragraph\">回答の手順</h2>
<p>アンケートはwebブラウザ上で行います。</p>

<ol>
<li class=\"margin\"><h3 class=list>アンケートフォームへのアクセス</h3>
このページの上部にあるメニューより「トップページ」へ移動し、「アンケート開始」のリンクをクリックしてください。<br></li>

<li class=\"margin\"><h3 class=list>SSL接続の確認</h3>
以下のような確認画面が表示されるので、「続ける」をクリックしてください。<br>
<img src=\"./img/ssl.png\"><br></li>

<li class=\"margin\"><h3 class=list>個人認証</h3>
アンケートへの回答の信頼性向上と、回答の修正を可能にするため個人認証をしていただきます。<br>
アカウント名と、nahaやpwにログインする際に使用するパスワードを入力
し、「ログイン」をクリックしてください。<br>

<img src=\"./img/login-e.png\"><br></li>

<li class=\"margin\"><h3 class=list>トップページ</h3>
アンケートフォームのトップページが表示されます。<br>
表示されているIDが自分のものであるか確認して、#{ARGV[0]}年度#{period}に受講した科目の設定をしてください。<br>
<img src=\"./img/index.jpg\" width=\"400\" height=\"300\"></li>

<li class=\"margin\"><h3 class=list>科目設定ページ</h3>
<font color=\"red\">#{ARGV[0]}年度#{period}</font>において<font color=\"red\">登録している全ての講義</font>にチェックをつけて送信してください。<br>
科目の設定は後から追加・削除が行えます。<br>
<img src=\"./img/addclass.jpg\" width=\"400\" height=\"300\"></li>

<li class=\"margin\"><h3 class=list>授業評価フォーム</h3>
チェックをつけた科目のアンケートフォームへのリンクがトップページに表示されますので、クリックして授業評価を行ってください。<br>
回答にかかる時間はひとつの科目につき10分程度です。
回答後、再びアクセスすることで回答の修正が行えます。<br>
<img src=\"./img/index1.jpg\" width=\"400\" height=\"300\">

</ol>


<?php
back();
?>

</div>
</div>
</body>
</html>
")
end
