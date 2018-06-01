
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ja">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <meta http-equiv="Content-Script-Type" content="text/javascript">
  <link rel="stylesheet" type="text/css" href="./r.css">
  <title>2018年度前期授業評価アンケート-対象科目</title>
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

      <?php
      $con = m_connect();
      $sql = "select * from classname;";
      $rs2 = m_query($con, $sql, "検索に失敗しました。");
      $maxrows = pg_num_rows($rs2);
      for ($i=0; $i<$maxrows; $i++) {
        $class_data[$i] = pg_fetch_row($rs2,$i,PGSQL_ASSOC);
      } 
      ?>

      <h2 class="paragraph">対象科目</h2>

      <h3 class="list">1年次対象科目</h3>
      <table border="1" cellspacing="0" cellpadding="5" class="kamoku leftspace">
        <tr>
          <th width="150">座学系</th>
		  <td>
            <?php
            foreach($class_data as $key) {
              // if ($key['grade'] == "1" && $key['prac'] == 0) {
              if (preg_match("/1/", $key['grade']) && $key['prac'] == 0) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
          </td>
        </tr>
        <tr>
          <th>実験・実習系</th>
          <td>
            <?php
            foreach ($class_data as $key ) {
              // if ($key['grade'] == "1" && $key['prac'] == 1) {
              if (preg_match("/1/", $key['grade']) && $key['prac'] == 1) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
          </td>
        </tr>
      </table>

      <h3 class="list">2年次対象科目</h3>
      <table border="1" cellspacing="0" cellpadding="5" class="kamoku leftspace">
        <tr>
          <th width="150">座学系</th>
          <td>
            <?php
            foreach($class_data as $key ) {
              // if ($key['grade'] == "2" && $key['prac'] == 0) {
              if (preg_match("/2/", $key['grade']) && $key['prac'] == 0) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
          </td>
        </tr>
        <tr>
          <th>実験・実習系</th>
          <td>
            <?php
            foreach($class_data as $key ) {
              // if ($key['grade'] == "2" && $key['prac'] == 1) {
              if (preg_match("/2/", $key['grade']) && $key['prac'] == 1) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
          </td>
        </tr>
      </table>

      <h3 class="list">3年次対象科目</h3>
      <table border="1" cellspacing="0" cellpadding="5" class="kamoku leftspace">
        <tr>
          <th width="150">座学系</th>
          <td>
            <?php
            foreach($class_data as $key ) {
              if ($key['grade'] == "3" && $key['prac'] == 0) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
          </td>
        </tr>
        <tr>
          <th>実験・実習系</th>
          <td>
            <?php
            foreach($class_data as $key ) {
              if ($key['grade'] == "3" && $key['prac'] == 1) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
          </td>
        </tr>
      </table>

      <h3 class="list">4年次対象科目</h3>
      <table border="1" cellspacing="0" cellpadding="5" class="kamoku leftspace">
        <tr>
          <th width="150">座学系</th>
          <td>
            <?php
            foreach($class_data as $key ) {
              if ($key['grade'] == "4" && $key['prac'] == 0) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
          </td>
        </tr>
        <tr>
		  <th>実験・実習系</th>
          <td>
            <?php
            foreach($class_data as $key ) {
              if($key['grade'] == "4" && $key['prac'] == 1) {
                echo $key['class_name'];
                echo "（".$key['kyouin']."）";
                echo "<br>";
              }
            }
            ?>
		</td>
	</tr>
        <tr>
                  <th>セミナー&卒業研究</th>
          <td>
            <?php
		foreach($class_data as $key ) {
		  if($key['grade'] == "4" && $key['prac'] == 2) {
		    echo $key['class_name'];
		    echo "（".$key['kyouin']."）";
		    echo "<br>";
		  }
		}
            ?>
                </td>
        </tr>
</table>

<h3 class="list">院生対象科目</h3>
<table border="1" cellspacing="0" cellpadding="5"
	class="kamoku leftspace">
	<tr>
		<th width="150">座学系</th>
		<td><?php
  foreach($class_data as $key ){
  if($key['grade'] == "5" && $key['prac'] == 0){
    echo $key['class_name'];
    echo "（".$key['kyouin']."）";
    echo "<br>";
  }
}
?>
		</td>
	</tr>
	<tr>
		<th>実験・実習系</th>
		<td><?php
  foreach($class_data as $key ){
    if($key['grade'] == "5" && $key['prac'] == 1){
      echo $key['class_name'];
      echo "（".$key['kyouin']."）";
      echo "<br>";
    }
  }
?>
		</td>
	</tr>
</table>

<?php
back();
?></div>
</div>
</body>
</html>
