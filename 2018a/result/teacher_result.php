
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ja">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Style-Type" content="text/css">
<link rel="stylesheet" type="text/css" href="r3_2005.css">

<?php
include("../global.php");
$con = m_connect();
echo "<title>2018年前期コメントと回答</title>\n";
echo "</head>\n";
echo "<body>\n";

/*作成:先代R班の方々。編集(1回目):e065755*/
echo '<h1 id=title>対象設問一覧</h1>';
$query = "select * from enq_list;";
$rs1 = m_query($con, $query, "検索に失敗しました。");
// 問題文の数
$max_enq = pg_num_rows($rs1);
for($i=0; $i<$max_enq; $i++) {
	$enq_data[$i] = pg_fetch_row($rs1, $i, PGSQL_ASSOC);
}
$sub_enq =0;
for ($i=0; $i<($max_enq); $i++) {
	$enq_type = $enq_data[$i]['enq_type'];
	$qnum = $enq_data[$i]['enq_num'];
	switch ($enq_type) {
		case 'text':
		  if($qnum == "Q35" && $qnum == "Q36"){
		    $qnum = strtoupper($enq_data[$i]['enq_num']);
                    echo "<h3>".$qnum.".".$enq_data[$i]['enq_str']."</h3>";
		  }
		  else{
			if($sub_enq > 0){
				echo "<h4>".$enq_data[$i]['enq_str']."</h4>\n";
				$sub_enq--;
			}else{
				$qnum = strtoupper($enq_data[$i]['enq_num']);
				echo "<h3>".$qnum.".".$enq_data[$i]['enq_str']."</h3>";
			}
		  }
			break;
		default:
			if(is_numeric($enq_type)){
				$qnum = strtoupper($enq_data[$i]['enq_num']);
				echo "<h3>".$qnum.".".$enq_data[$i]['enq_str']."</h3>";
				$sub_enq = intval($enq_type);
			}
			break;
	}
}

?>

<?php
/*結果を格納する配列群を配列で定義。*/
$qarr=array($aq1,$aq2,$aq3,$aq4,$aq5,$aq6,$aq7,$aq8);

/*科目のテーブルを取ってくる準備。*/
$sql="SELECT * FROM classname ORDER BY grade;";
$ar = m_query($con,$sql,"検索に失敗しました");
$maxrows=pg_num_rows($ar);


for($i=0; $i<$maxrows; $i++){
	/*"i"で指定したテーブルの行を取ってくる。*/
	$kamoku = pg_fetch_array($ar,$i,PGSQL_ASSOC);

	echo "<h1 id=\"title\">";
	echo $kamoku['class_name'].":".$kamoku['kyouin'];
	echo "</h1>";

	/*結果を格納する配列を初期化*/
	$aq1=array();
	$aq2=array();
	$aq3=array();
	$aq4=array();
	$aq5=array();
	$aq6=array();
	$aq7=array();
        $aq8=array();


	/*学生の要望を取ってくる処理。*/
	$sql="select * from ".$kamoku['table_name'].";";
	$rs2 =m_query($con,$sql,"検索に失敗しました。");
	$max=pg_num_rows($rs2);
	for($n=0; $n<$max; $n++){
		$arr=pg_fetch_array($rs2,$n,PGSQL_ASSOC);
		$aq1[$n]=$arr['q21_1'];
		$aq2[$n]=$arr['q21_2'];
		$aq3[$n]=$arr['q21_3'];
		$aq4[$n]=$arr['q21_4'];
		$aq5[$n]=$arr['q22'];
		$aq6[$n]=$arr['q35'];
                $aq7[$n]=$arr['q36'];
                $aq8[$n]=$arr['q37'];
	}

	//$filter=array(" ","　","なし","なし。","特に無し","特になし","とくになし","特になし。","とくになし。","特にない","とくにない","特にない。","とくにない。","問題なし。","問題なし","問題無し。","問題無し","特にないです","とくにないです","特にないです。","とくにないです。","問題ない","問題ない。","問題無い。","問題無い","ノーコメント","楽しかった","楽しかった。","説明なし","良い。","良い","よい","よい。","特に問題無し","特に問題無し。","適当","適当。","よいです","よいです。","良いです。","良いです","いいです","いいです。","hoge","おk");
	/*学生の解答は予測出来ないので変な解答を結果のページに反映させないようにある程度予想出来るコメントはここに書いておけば、フィルターとして除外できる。*/
	/*フィルターではじけてない場合があるのだけど、はじけている方が多いということでおおめにみてください。*/
	$filter=array(" ","　");
	//半角スペースと全角スペースにだけフィルターをかける。
	
	/*上で作成した自作フィルターと一致するものとNULLとを交換する。*/
	$n=0;
	foreach($aq1 as $val){
		foreach($filter as $fil){
			if($val == $fil){$aq1[$n]=NULL;}
			if($aq2[$n]==$fil){$aq2[$n]=NULL;}
			if($aq3[$n]==$fil){$aq3[$n]=NULL;}
                        if($aq4[$n]==$fil){$aq4[$n]=NULL;}
                        if($aq5[$n]==$fil){$aq5[$n]=NULL;}
			if($aq6[$n]==$fil){$aq6[$n]=NULL;}
			if($aq7[$n]==$fil){$aq7[$n]=NULL;}
			if($aq8[$n]==$fil){$aq8[$n]=NULL;}
		}
		$n++;
	}


	/*PHPの純正、フィルター。NULL削除。ついでに、重複も削除。*/
	$aq1=array_filter(array_unique($aq1));
	$aq2=array_filter(array_unique($aq2));
	$aq3=array_filter(array_unique($aq3));
	$aq4=array_filter(array_unique($aq4));
	$aq5=array_filter(array_unique($aq5));
	$aq6=array_filter(array_unique($aq6));
        $aq7=array_filter(array_unique($aq7));
        $aq8=array_filter(array_unique($aq8));



	/*教員の要望に対する回答を取ってくる処理。*/
	$sql="select * from teacher where kamoku = '".$kamoku['table_name']."';";
	$rs2=m_query($con,$sql,"検索に失敗しました。");
	$arr=pg_fetch_array($rs2,0,PGSQL_ASSOC);
	$sq1=$arr['a1'];
	$sq2=$arr['a2'];
	$sq3=$arr['a3'];
	$sq4=$arr['a4'];
	$sq5=$arr['a5'];
	$sq6=$arr['a6'];
        $sq7=$arr['a7'];
        $sq8=$arr['a8'];


	/*書き込みが無いものはテーブルを表示させない。*/
	if($aq1 == NULL && $aq2 == NULL && $aq3 == NULL && $aq4 == NULL && $aq5 == NULL && $aq6 == NULL && $aq7 == NULL && $aq8 == NULL && $sq1 == NULL && $sq2 == NULL && $sq3 == NULL && $sq4 == NULL && $sq5 == NULL && $sq6 == NULL && $sq7 == NULL && $sq8 == NULL){ echo "<h3>書き込みがありません。</h3>";
	}else{
		echo "<table border=\"1\">";
		/*配列の中に配列を格納。*/
		$nqarr=array($aq1,$aq2,$aq3,$aq4,$aq5,$aq6,$aq7,$aq8);

		$sarr=array($sq1,$sq2,$sq3,$sq4,$sq5,$sq6,$sq7,$sq8);
		$ques=array("Q21(1)","Q21(2)","Q21(3)","Q21(4)","Q22","Q35","Q36","Q37");
		$k=0;

		foreach($nqarr as $val){
			if($val != NULL | $sarr[$k] != NULL){
				echo"<tr>";
				echo"<td><h3>".$ques[$k]."</h3></td>";
				echo"<td>";
				if($val != NULL){
					echo"<ul>";
					foreach($val as $a){
						echo "<li>".$a."</li>";
					}
					echo"</ul>";
				}
				if($sarr[$k] != NULL){
					echo "<pre><b>  要望に対する回答</b></pre>";
					echo "<ul>";
					echo "<li>".$sarr[$k]."</li>";
					echo "</ul>";
				}
			}
			$k++;
			echo"</td>";
			echo"</tr>";
		}
		echo"</table>";
	}
}
?>


</body>
</html>
