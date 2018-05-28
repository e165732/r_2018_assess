# coding: utf-8
require 'fileutils'

# 第1引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[1] == "a" then
  period="前期"
elsif ARGV[1] == "b" then
  period="後期"
end

File.open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/manual.php","w") do |file|
  file.print("<?php
header(\"Content-Type: text/html;charset=UTF-8\");
?>

<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">
<html lang=\"ja\">

<head>
  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
  <meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
  <meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">
  <link rel=\"stylesheet\" type=\"text/css\" href=\"./r.css\">
  <title>#{ARGV[0]}年度#{period}授業評価アンケート-トップページ</title>
</head>

<body>
  <div id=\"container\">
    <div id=\"main\">
      <?php 
      include(\"./global.php\");
      title();
      ?>

      <center>
      <table id=\"margin\" border=\"3\">
        <tr>
          <td id=\"menu\"><a href=\"./index.html\">トップページ</a></td>
          <td id=\"menu\"><a href=\"./purpose.php\">実施目的・注意事項</a></td>
          <td id=\"menu\"><a href=\"./subjects.php\">対象科目</a></td>
          <td id=\"menu\"><a href=\"./process.php\">回答の手順</a></td>
          <td id=\"menu\"><a href=\"./enq.php\">設問一覧</a></td>
          <td id=\"menu\"><a href=\"./result/output.php\">現在の回答状況</a></td>
        </tr>
      </table>
      </center>

<!--
      <h2 class=\"paragraph\">授業評価アンケート 新時代へ突入！</h2>
      <ul>
        <li class=\"margin\"><h3 class=\"list\"><font color=\"red\">入力が簡単になりました！！ </font></h3></li>
        <li class=\"margin\"><h3 class=\"list\"><font color=\"red\">未入力項目があっても内容が消失しません！！</font></h3></li>
        <li class=\"margin\"><h3 class=\"list\"><font color=\"red\">皆様の熱いご要望にお応えし、設問数を減らすことに成功しました！！</font></h3></li>
      </ul>
-->

      <h2 class=\"paragraph\">アンケートをより手早く終わらせるために</h2>
      <p>簡単な動作説明と、アンケート実施できる環境についての説明です。従来のアンケートの回答手法と比べて、より簡単に、より素早く回答ができるようになりました。</p>
      <ul>
        <li class=\"margin\">
          <h3 class=\"list\">快適に楽しむ動作説明</h3>
          [Tab]キーを押すと、設問を移動することができます。<br>
          カーソルキーの上下で、選択肢の移動を行うことができます。<br>
          [Space]キーを押すと、選択肢をチェックすることができます。<br>
          [fn]＋カーソルキー上下でページをスクロールすることができます。<br>
          [Shift]+[Tab]キーを押すと、１つ前の設問に戻ることができます。</li>
          
        <li class=\"margin\">
          <h3 class=\"list\">Macでアンケートに回答されるときの注意</h3>
          Mac上のブラウザを使用して回答される場合、Tabキーでの設問移動を正常に動作させるためには以下の設定を行う必要があります。<br>

          <ol>
            <li>アップルメニューの<b>システム環境設定</b>を選択します。</li>
            <li>メニューの「<b>キーボード</b>」(Mac OS X v10.5.8 以前では「キーボードとマウス」) を選択します。</li>
            <li>必要に応じて「<b>キーボードショートカット</b>」を選択します。</li>
            <li>「<b>フルキーボードアクセス</b>」を「<b>すべてのコントロール</b>」に設定します。</li>
          </ol>
        </li>

        <li class=\"margin\">
        <h3 class=\"list\">動作確認をチェックした環境</h3>
        OSとブラウザの動作環境の確認を実施し、正常にアンケートが実施できると確認できた環境を記載しています。<br>
        以下の動作環境以外の環境でお使いの方は、使用したときの動作確認の報告を是非R班宛にお願いします。<br>
        </li>

        <li class=\"margin\">
        <h4 class=\"list\">Mac OSを使用する場合</h4>
        <h5>対応しているブラウザ</h5>
        Safari<br>
        Firefox<br>
        Chrome<br>
        Opera<br>
        </li>

        <li class=\"margin\">
        <h4 class=\"list\">Windows OSを使用する場合</h4>
        <h5>対応しているブラウザ</h5>
        Firefox<br>
        Chrome<br>
        Opera<br>
        Internet Exprolare<br>
        </li>

        <li class=\"margin\">
        <h4 class=\"list\">Linux OSを使用する場合</h4>
        <h5>対応しているブラウザ</h5>
        Firefox<br>
        Opera<br>
        </li>

        <li class=\"margin\">
        <h3 class=\"list\">注意</h3>
        iPhoneにも対応していますので、興味がある方は是非お試しください。<br>
        スクロールをする際の動作の快適さは、お使いの環境によって若干の違いがあります。<br>
        </li>
      </ul>

      <?php
      back();
      // Do Basic authentication
      $need_proxy_auth = 0;
      $proxy_auth_user = 'username';
      $proxy_auth_pass = 'password';
      ?>

    </div>
  </div>
</body>
</html>
")
end
