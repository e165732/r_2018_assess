
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang="ja">

   <head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
   <meta http-equiv="Content-Style-Type" content="text/css">
   <link rel="stylesheet" type="text/css" href="r3_2005.css">

   <?php
 /* セッションを作成 */
session_start();
/* 画像ファイルがおいてあるディレクトリを指定してください。 */
$graph_dir = 'plot';

include("../global.php");
$kamoku = $_GET['kamoku'];
$ex = $_GET['ex'];

// PostgreSQL サーバに接続
$con = m_connect();

// セッションに保存
//	session_register("s_kamoku");
$_SESSION["s_kamoku"] = $kamoku;
$_SESSION["s_ex"] = $ex;
?>

<?php
echo "<title>".$kamoku."</title>\n";
?>
</head>
<body>

<?php
  /* PostgreSQL サーバに接続 */
$con = m_connect();
/*回答状況のチェック*/
$query = "select * from $kamoku ;";
$rs = m_query($con, $query, "検索に失敗しました。");
$maxrows = pg_num_rows($rs);


if ($maxrows!=0){
  /* 検索結果を取得 */
  if (!($rowdata = pg_fetch_all($rs))) {
    die_exit("データは存在しません");
  }
 }

// 検索結果を解放
pg_free_result($rs);

?>

<?php
$query1 = "select * from classname where table_name='$kamoku';";
$rs1 = m_query($con, $query1, "検索に失敗しました。");
$query2 = "select * from ".$kamoku.";";
$rs2 = m_query($con, $query2, "失敗");
$query3 = "select * from enq_list;";
$rs3 = m_query($con, $query3, "検索に失敗しました。");

$rowdata = pg_fetch_array($rs1,0,PGSQL_ASSOC);
echo '<h1 id="title">';
echo $rowdata['class_name']."の授業評価</h1>\n";
echo "<center><font size=4><br>";
$check_row = pg_num_rows($rs2);
echo $check_row."人/ ";
$rowdata = pg_fetch_array($rs1,0, PGSQL_ASSOC);
echo $rowdata['touroku']."人";

echo "<span class=\"response_rate\">(".number_format(($check_row*100/$rowdata['touroku']),1)."%)</span>\n";
echo "【 回答者 / 登録者 / (回答率) 】";
echo "</font></center><br>";
echo "<hr />\n";
?>

<!--<div><B><FONT color="#ff0000">閲覧上の注意</FONT></B></div>-->
<!---->
<!--<UL>-->
<!--	<LI>各設問の選択肢には点数が振ってあり、基本的に、点数が高いほど良い 評価になります。<BR>-->
<!--	（低い方が良い(Q12)、中間の方が良い(Q6,Q10)設問もあります。）	-->
<!--	-->
<!--	<LI><B>平均</B>とは、その設問で回答者がつけた点数の平均値のことです。-->
<!--	-->
<!--	<LI><B>全体平均</B>とは、全科目における平均のことです。	-->
<!--	-->
<!--	<LI>選択肢の中には「該当しない（〜がなかった）」など、点数のない（= 評価できない）ものがあります。<BR>-->
<!--	<B>評価該当率</B>とは、その設問に答えた回答者のうち、何％が実際に評 価をした（=点数のついた選択肢を選んだ）かを示す割合です。<BR>-->
<!--	この割合が高いほど、平均値はより信頼できる値といえます。-->
<!---->
<!--</UL>-->
<!--<hr>-->

<?php
     // 配列の定義
$color = array('red','yellow','greenyellow','aquamarine','dodgerblue','purple','gray');

// 問題文の数
$max_enq = pg_num_rows($rs3);

for($i=0; $i<$max_enq; $i++) {
  $enq_data[$i] = pg_fetch_row($rs3, $i, PGSQL_ASSOC);
 }

$repnum = 1;
$sub_enq=0;
for ($i=0; $i<($max_enq-1); $i++) {
  $enq_type = $enq_data[$i]['enq_type'];

  // 座学系の授業なら実験系の問題をスルーする                             
  #if($ex != 1 && $enq_data[$i]['enq_prac'] == "1")continue;              
  if($ex != 2 && $enq_data[$i]['enq_prac'] == "2"){
    continue;
  }
  elseif($ex != 1 && $enq_data[$i]['enq_prac'] == "1"){
    continue;
  }
  elseif($ex == 2  && $enq_data[$i]['enq_prac'] != "2"){
    continue;
  }
  
  if($sub_enq > 0){
    echo "<h3>".$enq_data[$i]['enq_str']."</h3>\n";
    echo "<div class=\"topic-content\">\n";
    $sub_enq--;
  }else{
    $qnum = strtoupper($enq_data[$i]['enq_num']);
    echo "<h3 class=\"topic\">".$qnum.".".$enq_data[$i]['enq_str']."</h3>\n";
    echo "<div class=\"topic-content\">\n";
  }

  switch ($enq_type) {
  case 'radio':
    // 回答文の数
    $query4 = "select * from ans_list where ans_num = '".$enq_data[$i]['enq_num']."'";
    $rs4 = m_query($con, $query4, "検索に失敗しました。");
    $max_ans = pg_num_rows($rs4);
    for ($j=0; $j<$max_ans; $j++) {
      $ans_data[$j] = pg_fetch_row($rs4, $j, PGSQL_ASSOC);
    }
    $all = 0;
    echo "<table><tr><td>\n";
    echo '<img src="./'.$graph_dir.'/'.'nen/'.$kamoku.'/'.$qnum.'.png" width=210 height=210>'."\n </td>"; 
			
    // 回答ごとの人数と色を表示する
    echo "<td>";
    for ($j=0; $j<$max_ans; $j++) {
      $query5 = "select * from $kamoku where ".$enq_data[$i]['enq_num']."=".($j+1).";";
      $rs5 = m_query($con, $query5, "検索に失敗しました。");
      $check_row = pg_num_rows($rs5);
      echo "<font color=\"".$color[$j]."\"><big>■</big></font>".($j+1).".".$ans_data[$j]['ans_str']."　".$check_row."人<br>\n";
    }
    echo "</td></tr></table>";
    echo "</div>\n";
    break;

  case 'text':
    $qnum = $enq_data[$i]['enq_num'];
    $query6 = "select $qnum from $kamoku where $qnum != '';";
    $rs6 = m_query($con, $query6, "検索に失敗しました。");
    $arr = pg_fetch_all($rs6);
    
    $loop_num = 0;
    echo "<ul>";
    for ($loop_num=0;  $loop_num<count($arr);  ++$loop_num) {
      $comment =  $arr[$loop_num][$qnum];
      if ( $comment==" " ) { continue; }
      echo "<li>".$comment;
      echo "</li>\n";
    }
    echo "</ul>\n";
    if ($qnum == "q35") $repnum = 6;
    $rep_a = "a$repnum";
    $query = "select $rep_a from teacher where kamoku = '$kamoku' ;";
    $rs7 = m_query($con, $query, "検索に失敗しました。");
    $reply = pg_fetch_row($rs7, 0, PGSQL_ASSOC);
    echo "<pre><b>   要望に対する回答</b></pre>\n";
    echo "<ul>\n";
    echo nl2br($reply[$rep_a]);
    echo "</ul>\n";
    echo "</div>\n";
    echo "<br>";
    $repnum++;
    break;

  default:
    if(is_numeric($enq_type)){
      $sub_enq = intval($enq_type);
    }
    echo "</div>\n";
    break;
  }
 }

// オリジナル問題
$query8 = "select org_enq from original_q where class_id = '$kamoku' ;";
$rs8 = m_query($con, $query8, "検索に失敗しました。");
$arr = pg_fetch_all($rs8);
if (nl2br($arr[0]['org_enq']) != NULL) {
  $org_qnum = $enq_data[$max_enq-1]['enq_num'];
  $qnum2 = strtoupper($org_qnum);
  echo "<h3 >".$qnum2."は担当教員による独自設問となっています。</h3>\n";
  echo "<h3 class=\"topic\">".$qnum2.".".$arr[0]['org_enq'];
  echo "</h3>\n";
  $query9 = "select $org_qnum from $kamoku where $org_qnum != '' ;";
  $rs9 = m_query($con, $query9, "検索に失敗しました。");
  $arr = pg_fetch_all($rs9);
  echo "<ul>\n";
  for ($loop_num=0;  $loop_num<count($arr);  ++$loop_num) {
    if ( $arr[$loop_num][$org_qnum] == '' ) { break; }
    echo "<li>".$arr[$loop_num][$org_qnum]."</li>\n";
  }
  echo "</ul>\n";
 }
?>

<h3 class="topic">この講義の講師は要望に対する回答を入力してください。</h3>
入力時の改行はそのまま画面に反映されます。
<br>
&lt;ol&gt;〜&lt;/ol&gt;、&lt;ul&gt;〜&lt;/ul&gt;で順序有りリストや順序無しリストを記述し、リストの各項目は&lt;li&gt;で記述します。
<br>
<br>
<div class="topic-content">
														      <?php
$query = "select directory from teacher where kamoku = '$kamoku' ;";
$rs = m_query($con,$query,"検索に失敗しました。");
$arr = pg_fetch_all($rs);
?>
<form action="https://r.st.ie.u-ryukyu.ac.jp/assessment/2013a/result/teacher/<?php echo $arr[0]['directory']."/edit_".$kamoku.".php";?>" 
  target="answer"
  onclick="window.open(this.action, 'answer', 'width=820, menubar=no, to\
olbar=no, scrollbars=yes'); return false;" >
  <input class="leftspace" type="submit" value="要望に対する回答を入力" />
  </form>

<br><br>
</div>
</body>
</html>
