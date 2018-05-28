# -*- coding: utf-8 -*-
#第1引数に年度、第2に引数にa or b(前期or後期)を入れる(例$ruby global.rb 2014 a)
#require 'net/http'
require 'socket'

# 前期or後期の判断
if ARGV[1] == "a" then
  dbperiod="a"
  period="前期"
elsif ARGV[1] == "b" then
  dbperiod="b"
  period="後期"
end

#ipアドレス取得
#ip=Net::HTTP.get('ifconfig.me','/ip').strip!
#ipアドではなくサーバーネームを取るようにしました7/10
#サーバーネーム取得
ip=Socket.gethostname
#ディレクトリを取得
#dir=Dir::pwd
#dirary=dir.split("/")
#i=0
#while i < dirary.length
# if dirary[i] == "html"
#  i+=1
#  dirnum=i
#end
# i+=1
#end
#homedir=dirary[dirnum]
#dirnum+=1
#while dirnum < dirary.length-1
# homedir << "/#{dirary[dirnum]}"
# dirnum+=1
#end


w = open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/global.php","w")

w.puts("<?php")
w.puts("define(\"DATABASE_NAME\", \"#{ARGV[0]}#{dbperiod}\");")
w.puts("")
w.puts("")
w.puts("/* エラー表示の抑制 */")
w.puts("error_reporting(0);")
w.puts("")
w.puts("/* 終了関数の定義 */")
w.puts("function die_exit($message) {")
w.puts("    /* ログインしているかどうかによりトップの URL を変更 */")
w.puts("    $top_url = ($_SERVER['PHP_AUTH_USER'] == \"\" ? \"../index.html\" : \"./ssl/index.php\");")
w.puts("    //echo '<p class=\"error\">. $message .</p>';")
w.puts("    echo \"$message\";")
w.puts("    back();")
w.puts("    echo '<body></body>';")
w.puts("    echo '<html></html>';")
w.puts("    exit;")
w.puts("}")
w.puts("")
w.puts("/* ログイン済みか確認 */")
w.puts("function check_login() {")
w.puts("    if(!(isset($_SERVER['PHP_AUTH_USER']))){")
w.puts("        die_exit(\"ログインされていないか、セッションがタイムアウトしました。ログインして下さい。\");")
w.puts("    }")
w.puts("}")
w.puts("")
w.puts("/* 入力した値のサイズをチェック */")
w.puts("function finalcheck_length($str, $maxlen, $must, $name) {")
w.puts("    $len = strlen($str);")
w.puts("    if ($must && $len == 0) {")
w.puts("        die_exit(\"$name が入力されてません。必須項目です。\");")
w.puts("    }")
w.puts("    if ($len > $maxlen) {")
w.puts("        die_exit(\"$name は $len 文字以下で入力して下さい。全角文字は、一文字で二文字分と計算されます。\");")
w.puts("    }")
w.puts("}")
w.puts("")
w.puts("/* SQL 文字列のエスケープ */")
w.puts("function escape_string($sql, $quote = TRUE) {")
w.puts("    if ($quote && strlen($sql) == 0) {")
w.puts("        return \"null\";")
w.puts("    }")
w.puts("    return ($quote ? \"'\" : \"\") .")
w.puts("        pg_escape_string($sql) .")
w.puts("        ($quote ? \"'\" : \"\");")
w.puts("}")
w.puts("")
w.puts("/* PostgreSQL サーバに接続 */")
w.puts("function m_connect() {")
w.puts("    //変更点2014")
#ここは変更しないといけないか？
w.puts("    $con = @pg_connect(\"host=localhost user=postgres dbname=\".DATABASE_NAME);")
w.puts("    if (!$con) {")
w.puts("        die_exit(\"データベースに接続出来ませんでした。\".DATABASE_NAME);")
w.puts("    }")
w.puts("    /* データベースと、PHP の内部文字コードが違う場合 */")
w.puts("    //pg_set_client_encoding($con, \"EUC\");")
w.puts("    return($con);")
w.puts("}")
w.puts("")
w.puts("/* データベースとの接続を切り離す */")
w.puts("function m_close($con) {")
w.puts("    return @pg_close($con);")
w.puts("}")
w.puts("")
w.puts("/* SQL 文を実行 */")
w.puts("function m_query($con, $query, $errmessage) {")
w.puts("    $rtn = @pg_query($con, $query);")
w.puts("    if (!$rtn) {")
w.puts("        /* エラーメッセージに SQL 文を出すのはセキュリティ上良くない！！ */")
w.puts("        $msg = $errmessage . \"<br>\n\" .")
w.puts("            @pg_last_error($con) . \"<br>\n\" .")
w.puts("            \"<small><code>\" . htmlspecialchars($query) .")
w.puts("            \"</code></small>\n\";")
w.puts("        m_close($con);")
w.puts("        die_exit($msg);")
w.puts("    }")
w.puts("    return($rtn);")
w.puts("}")
w.puts("")
w.puts("/*ページ最下段に表示*/")
w.puts("function back(){")
w.puts("    define(NENDO,#{ARGV[0]});")
w.puts("    $year = NENDO;")
w.puts("    echo \"<hr>\";")
#リンク先アド状況により変更
w.puts("    echo \"<a href=\\\"https://#{ip}/assessment/\\\">R班トップページ</a>\";")
w.puts("    echo \"<p class=\\\"copyright\\\">\";")
w.puts("    echo \"$year 年度情報工学実験3 調査と解析(R)班<br>\";")
w.puts("    echo \"<a href=\\\"mailto:r-inquiry@ms.ie.u-ryukyu.ac.jp?subject=$year 年度#{period}授業評価アンケートについて\\\">r-inquiry@ms.ie.u-ryukyu.ac.jp</a>\";")
w.puts("    echo \"</p>\";")
w.puts("}")
w.puts("")
w.puts("function back2($flag){")
w.puts("    echo \"<hr>\";")
w.puts("    if ($flag != 1) {")
#状況により変更
w.puts("        echo \"<a href=\\\"https://#{ip}/assessment/\\\">R班トップページ</a>\";")
w.puts("    }")
w.puts("    echo \"<p class=\\\"copyright\\\">\";")
w.puts("    echo \"#{ARGV[0]}年度情報工学実験3 調査と解析(R)班<br>\";")
w.puts("    echo \"<a href=\\\"mailto:r-inquiry@ms.ie.u-ryukyu.ac.jp?subject=#{ARGV[0]}年度#{period}授業評価アンケートについて\\\">r-inquiry@ms.ie.u-ryukyu.ac.jp</a>\";")
w.puts("    echo \"</p>\";")
w.puts("}")
w.puts("define(NENDO,#{ARGV[0]});")
w.puts("function title(){")
w.puts("    echo \"<h1 class=title>\";")
w.puts("    echo NENDO;")
w.puts("    echo \"年度#{period}授業評価アンケート</h1>\";")
w.puts("}")
w.puts("")
w.puts("function nendo(){")
w.puts("    define(NENDO,#{ARGV[0]});")
w.puts("    //$nendo = NENDO;")
w.puts("    echo NENDO;")
w.puts("}")
w.puts("")
w.puts("?>")

w.close

