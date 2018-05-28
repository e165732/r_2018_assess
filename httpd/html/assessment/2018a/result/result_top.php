
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta http-equiv="Content-Style-Type" content="text/css">
		<meta http-equiv="Content-Script-Type" content="text/javascript">
		<link rel="stylesheet" type="text/css" href="r3_2005.css">

		<title>                                                         
                2018年度前期 授業評価アンケート                                
                </title>
	</head>
	<body>
		<h1 id="title">2018年度 前期 授業評価アンケート</h1>

		<hr>

		<div id="intro">
			この「調査・解析」結果は、
   2018年度情報工学実験3の 
			調査と解析(R)班 により作成されています。
		</div>

		<h3 class="topic"> 調査目的</h3>
		<p class="topic-content">
			今回の
			<span style ="color:#ff0000">「授業評価アンケート」</span>
			は、情報工学科が提供している専門科目に対する、
			学生主体による評価を行うことが目的です。
		</p>

		<h3 class="topic">個人情報の取り扱いについて</h3>
		<p class="topic-content">
			今回収集したデータについて、
			アンケートにより得られた個人情報を
			第三者(学生、教官、部外者など)に公開することや、
			個人が特定できるような状態にすることは一切ありません。
			また、いかなる回答も個人の成績評価には影響ありません。
		</p>


		<h3 class="topic"> アンケート参加者数</h3>
		<table border=0 summary=" ">
			<tr> 
			<tr><img src="./plot/zentai/All.png" width=300 height=300></td>
			</tr>
		</table> 

<?php
  include("../global.php");
  $con = m_connect();

$All=0;
echo"<font color=\"blue\">";
echo "学部生の<br>";
for($i=1; $i<=4; $i++){
  $query="select id from addclass where grade='$i';";
  $rs=m_query($con,$query,"人数検索に失敗しました。");
  $check_row=pg_num_rows($rs);
  $All=$All+$check_row;
  if($check_row != 0){
    echo "$i";
    echo "年次は";
    echo "$check_row";
    echo "人、";
  } 
 }
echo "<br>学院生の<br>";
for($i=5; $i<=6; $i++){
  $query="select id from addclass where grade='$i';";
  $rs=m_query($con,$query,"人数検索に失敗しました。");
  $check_row=pg_num_rows($rs);
  $All=$All+$check_row;
  if($check_row != 0){
    echo $i-4;
    echo "年次は";
    echo "$check_row";
    echo "人、";
  }
 }
echo "計".$All."人の方がアンケートに参加してくださいました。</font>";

?>
		<p class="notice">ご協力、誠にありがとうございました。</p>
		<hr>
		<p>2018年度情報工学実験3 調査と解析(R)班<br><a href="mailto:r-inquiry@ms.ie.u-ryukyu.ac.jp?subject=2018年度前期授業評価アンケートについて">r-inquiry@ms.ie.u-ryukyu.ac.jp</a></p>

	</body>
</html>
