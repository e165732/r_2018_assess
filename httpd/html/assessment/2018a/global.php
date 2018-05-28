<?php
define("DATABASE_NAME", "2018a");


/* エラー表示の抑制 */
error_reporting(0);

/* 終了関数の定義 */
function die_exit($message) {
    /* ログインしているかどうかによりトップの URL を変更 */
    $top_url = ($_SERVER['PHP_AUTH_USER'] == "" ? "../index.html" : "./ssl/index.php");
    //echo '<p class="error">. $message .</p>';
    echo "$message";
    back();
    echo '<body></body>';
    echo '<html></html>';
    exit;
}

/* ログイン済みか確認 */
function check_login() {
    if(!(isset($_SERVER['PHP_AUTH_USER']))){
        die_exit("ログインされていないか、セッションがタイムアウトしました。ログインして下さい。");
    }
}

/* 入力した値のサイズをチェック */
function finalcheck_length($str, $maxlen, $must, $name) {
    $len = strlen($str);
    if ($must && $len == 0) {
        die_exit("$name が入力されてません。必須項目です。");
    }
    if ($len > $maxlen) {
        die_exit("$name は $len 文字以下で入力して下さい。全角文字は、一文字で二文字分と計算されます。");
    }
}

/* SQL 文字列のエスケープ */
function escape_string($sql, $quote = TRUE) {
    if ($quote && strlen($sql) == 0) {
        return "null";
    }
    return ($quote ? "'" : "") .
        pg_escape_string($sql) .
        ($quote ? "'" : "");
}

/* PostgreSQL サーバに接続 */
function m_connect() {
    //変更点2014
    $con = @pg_connect("host=localhost user=postgres dbname=".DATABASE_NAME);
    if (!$con) {
        die_exit("データベースに接続出来ませんでした。".DATABASE_NAME);
    }
    /* データベースと、PHP の内部文字コードが違う場合 */
    //pg_set_client_encoding($con, "EUC");
    return($con);
}

/* データベースとの接続を切り離す */
function m_close($con) {
    return @pg_close($con);
}

/* SQL 文を実行 */
function m_query($con, $query, $errmessage) {
    $rtn = @pg_query($con, $query);
    if (!$rtn) {
        /* エラーメッセージに SQL 文を出すのはセキュリティ上良くない！！ */
        $msg = $errmessage . "<br>
" .
            @pg_last_error($con) . "<br>
" .
            "<small><code>" . htmlspecialchars($query) .
            "</code></small>
";
        m_close($con);
        die_exit($msg);
    }
    return($rtn);
}

/*ページ最下段に表示*/
function back(){
    define(NENDO,2018);
    $year = NENDO;
    echo "<hr>";
    echo "<a href=\"https://mitsukawa-no-MacBook-Pro.local/assessment/\">R班トップページ</a>";
    echo "<p class=\"copyright\">";
    echo "$year 年度情報工学実験3 調査と解析(R)班<br>";
    echo "<a href=\"mailto:r-inquiry@ms.ie.u-ryukyu.ac.jp?subject=$year 年度前期授業評価アンケートについて\">r-inquiry@ms.ie.u-ryukyu.ac.jp</a>";
    echo "</p>";
}

function back2($flag){
    echo "<hr>";
    if ($flag != 1) {
        echo "<a href=\"https://mitsukawa-no-MacBook-Pro.local/assessment/\">R班トップページ</a>";
    }
    echo "<p class=\"copyright\">";
    echo "2018年度情報工学実験3 調査と解析(R)班<br>";
    echo "<a href=\"mailto:r-inquiry@ms.ie.u-ryukyu.ac.jp?subject=2018年度前期授業評価アンケートについて\">r-inquiry@ms.ie.u-ryukyu.ac.jp</a>";
    echo "</p>";
}
define(NENDO,2018);
function title(){
    echo "<h1 class=title>";
    echo NENDO;
    echo "年度前期授業評価アンケート</h1>";
}

function nendo(){
    define(NENDO,2018);
    //$nendo = NENDO;
    echo NENDO;
}

?>
