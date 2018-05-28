<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ja">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <meta http-equiv="Content-Script-Type" content="text/javascript">
  <link rel="stylesheet" type="text/css" href="./r.css">
  <title>2018年度前期授業評価アンケート-アンケートの設問内容</title>
</head>

<body>
  <div id="container">
    <div id="main">
      <?php
      include("./global.php");
      title();
      ?>

      <center>
      <table border="3">
        <tr>
          <td id="menu"><a href="./index.html">トップページ</a></td>
          <td id="menu"><a href="./purpose.php">実施目的・注意事項</a></td>
          <td id="menu"><a href="./subjects.php">対象科目</a></td>
          <td id="menu"><a href="./process.php">回答の手順</a></td>
          <td id="menu"><a href="./enq.php">設問一覧</a></td>
          <td id="menu"><a href="./result/output.php">現在の回答状況</a></td>
        </tr>
      </table>
      </center>

      <h2 class="paragraph">アンケート項目</h2>
      
       <h4 class="annotation">セミナー＆卒業研究の問題は設問23以降からです。1~22の問題は含まれません。</h4>

      <?php
      //データベースに接続
      $con = m_connect();
      //問題文などを取得
      $sql = "select * from enq_list;";
      $rs = m_query($con, $sql, "検索に失敗しました。");
      $max = pg_num_rows($rs);
      for($i=0; $i<$max; $i++){
      	$enq_data[$i] = pg_fetch_row($rs, $i, PGSQL_ASSOC);
      }
      echo '<ol type="1">';
      $sub_enq=0;
      for ($i=0; $i<$max; $i++) {
      	$enq_type = $enq_data[$i]['enq_type'];
      	if($sub_enq <= 0) {
          switch ($enq_type) {
            case 'radio':
                  echo '<li>'.$enq_data[$i]['enq_str'] .'</li>';
                  break;

            case 'text':
                 echo '<li>'.$enq_data[$i]['enq_str'] .'</li>';
                 break;

            default:
                 if (is_numeric($enq_type)) {
                   echo '<li>'.$enq_data[$i]['enq_str'] .'</li>';
                   $sub_enq = intval($enq_type);
                 }
                 break;
          }

        } else {
          echo $enq_data[$i]['enq_str'];
          echo "<br>";
          $sub_enq--;
        }
      }
      echo "</ol>";
      echo "<h4 class=\"annotation\">座学系の講義には実験・演習に関する質問はありません。</h4>";
      echo "<h4 class=\"annotation\">セミナーに関する質問はそれ以外に関する質問とは別になっています。</h4>";
      echo "<h4 class=\"annotation\">担当教員による独自設問は、ない場合もあります。</h4>";

      back();
      ?>
    </div>
  </div>
</body>
</html>
