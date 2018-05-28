# -*- coding: utf-8 -*-

# 第1引数にa or b(前期or後期)
# 前期or後期の判断
if ARGV[0] == "a" then
 period="前期"
elsif ARGV[0] == "b" then
 period="後期"
end

w = open("../../httpd/html/assessment/#{ARGV[0]}#{ARGV[1]}/ssl/edit.php","w")

w.print("<?php
/* セッションを作成 */
session_start();
?>

<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">
<html lang=\"ja\">
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">
<meta http-equiv=\"Content-Script-Type\" content=\"text/javascript\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"../r.css\">
<title>調査解析班#{period}授業評価アンケート</title>
<script type=\"text/javascript\">
<!--
function goindex(){ location.href = \"./index.php\" }
-->
</script>
</head>
<body onLoad=\"setTimeout('goindex()',3000)\">

<div id=\"container\">
<div id=\"main\"><?php
include(\"../global.php\");
title();
$sql_userid = getenv(\"REMOTE_USER\");
$kamoku = $_SESSION['s_kamoku'];
$ex = $_SESSION['s_ex'];
// ログイン済みか確認
check_login();
// PostgreSQL サーバに接続
$con = m_connect();
$query = \"select * from $kamoku where id = '$sql_userid';\";
// 検索を実行
$rs = m_query($con, $query, \"データの検索に失敗しました。\");
// 検索件数
$maxrows = pg_num_rows($rs);
// 新規登録を実行
if ( $maxrows==0 )
{
  $query2 = \"select * from enq_list;\";
  $rs2 = m_query($con, $query2, \"データの検索に失敗しました。\");
  $max = pg_num_rows($rs2);
  for($i=0; $i<$max; $i++){
    $enq_data[$i] = pg_fetch_row($rs2, $i, PGSQL_ASSOC);
    if($ex != 2 && $enq_data[$i]['enq_prac'] =='2'){
        continue;
      }
                elseif($ex != 1 && $enq_data[$i]['enq_prac'] =='1'){
        continue;
                }
     elseif($ex == 2 && $enq_data[$i]['enq_prac'] !='2'){
        continue;
      }
     $hissu[] = $enq_data[$i]['enq_hissu'];
     $prac[] = $enq_data[$i]['enq_prac'];
     }

    $data[] = escape_string($sql_userid);
    $column_num = pg_num_fields($rs);
    for($i=1; $i<$column_num; $i++){
      $qnum = pg_field_name($rs,$i);
      $data[] = escape_string($_POST[$qnum]);
      }

     for($i=1; $i<($column_num-1); $i++){
       if($hissu[$i-1] != '1') continue;
        if($ex != 2 && $prac[$i-1] =='2'){
            continue;
                }
         elseif($ex != 1 && $prac[$i-1] =='1'){
            continue;
          }
         elseif($ex == 2 && $prac[$i-1] !='2'){
            continue;
          }
         if($data[$i] == \"null\"){
           $qnum = strtoupper(pg_field_name($rs,$i));
           echo '<p class=\"caution\">'.$qnum.'が未選択です。<br>';
           $flag = TRUE;
           }
          }
         if($flag){
           echo \"<br><font size=4><a href=form.php?kamoku=\";
           print $kamoku;
           if($ex==1){
               echo \"&ex=1\";
             }
            elseif($ex==2){
               echo \"&ex=2\";
             }
            echo \">戻る</a></font></p>\";
            //追記
            echo \"<br><font size=4><a href=index.php\";
            echo \">アンケート中止</a></font></p>\";
            //終了
            exit;
            }
           $data = implode(\", \", $data);
           $query = \"insert into $kamoku values ($data)\";
}
//追加登録を実行
else
{
           $userid = escape_string($sql_userid);
           $column_num = pg_num_fields($rs);
           for($i=1; $i<$column_num; $i++){
             $qnum[$i] = pg_field_name($rs,$i);
             $data[$i] = escape_string($_POST[$qnum[$i]]);
             $setsql[$i] = $qnum[$i].\"=\".$data[$i];
             }
            $setsqlstr = implode(\", \", $setsql);
            $query = \"update $kamoku set $setsqlstr where id = $userid\";
}

// 登録を実行
$rtn = m_query($con, $query, \"データの書き込みに失敗しました。\");

echo \"<center>\";

switch (pg_affected_rows($rtn))
{
            case 1:
              echo(\"<p class=\\\"caution\\\">送信しました。</p>\\n\");
             echo(\"<p class=\\\"caution\\\">3秒後に自動で授業選択ページに戻ります</p>\\n\");
             break;
             default:
              die_exit(\"データ書き込みできませんでした。\");
}

// 切断
m_close($con);

echo \"</center>\";
//追記
echo \"<br><font size=4><a
href=index.php\";
echo \">アンケート終了</a></font></p>\";
//終了
back2(1);
?></div>
</div>

</body>
</html>

")
w.close
