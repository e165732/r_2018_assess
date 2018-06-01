
<?php
  /* セッションを作成 */
  session_start();
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ja">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <meta http-equiv="Content-Script-Type" content="text/javascript">
  <link rel="stylesheet" type="text/css" href="../r.css">
  <title>調査解析班授業評価アンケート</title>

  <script type="text/javascript">
    //<!--
    //function next(){ location.href = "http://r.st.ie.u-ryukyu.ac.jp/assessment/2013a/index.html" }
    //-->
  </script>
</head>

<body onLoad="setTimeout('close()',3000)">

<div id="container">
<div id="main">

<?php
/*共通設定ファイルの読み込み*/
include("../global.php");
title();

/*環境関数REMOTE_USERを取得*/
$userid = escape_string(getenv("REMOTE_USER"));
if($userid == NULL){
  echo "REMOTE_USER error";
}
/* セッションに保存 */
session_destroy();
$_SESSION["s_userid"] = $userid;

/* PostgreSQL サーバに接続 */
$con = m_connect();

/*SQL用にちょっと変換*/
$sql_userid = escape_string(getenv("REMOTE_USER"));
echo "<h2 class=\"paragraph\">".getenv("REMOTE_USER")."さんのアンケートページ</h2>\n";

/* ログイン済みか確認 */
check_login();

// ログアウト処理
$_SESSION = array();
if (isset($_COOKIE["PHPSESSID"])) {              // session_name() -> PHPSESSID
  setcookie("PHPSESSID", '', time()-1800, '/');  // session_name() -> PHPSESSID
}
session_destroy();

echo "<center>";
echo "<p class=\"caution\">アンケートお疲れさまでした。</p>";
echo "<p class=\"caution\">このウィンドウは3秒後に、自動的に閉じます。</p>";
echo "</center>";

back2(1);
?>

</div>
</div>

</body>
</html>

