
<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->

<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='http://r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">

  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $group_name; ?></title>
	<link href="<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
  </head>

<body>

<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="/"><img src="<?php echo $themeroot; ?>/images/logo.png" border="0" alt="R-Forge Logo" /> </a> </td> </tr>
</table>


<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->

<table border="0" align="left" width="100%" cellpadding="2" cellspacing="2">
<tr valign="top">
<td align="left">
<?php if ($handle=fopen('http://'.$domain.'/export/projtitl.php?group_name='.$group_name,'r')){
$contents = '';
while (!feof($handle)) {
	$contents .= fread($handle, 8192);
}
fclose($handle);
echo $contents; } ?>
<!-- end of project description -->
</td>
<td align="right"><img src="reefree_logo_white_balance_small.jpg" width="250" height="167"></td>
<td width="100%">&nbsp;</td>
</tr>
<tr>
  <td><table cellpadding="2" cellspacing="2" align="left" border="0">
<td><a href="NO3.png"><img src="NO3_small.png" width="188" height="188"></td>
<td><a href="Kh.png"><img src="Kh_small.png" width="188" height="188"></td>
</tr></table>
</td>
<td><a href="all.png"><img src="all_small.png" width="250" height="188"></td>
<td width="100%">&nbsp;</td>
</tr>
</table>

<h3>Installation</h3>
<ol>
<li>Install R</li>
<li><a href="http://r-forge.r-project.org/plugins/scmsvn/viewcvs.php/pkg/?root=reefree">Download reefree.R</a></li>
<li>Execute reefree.R</li>
</ol>

<h3>Your data</h3>
<ol>
<li>Mantain an Openoffice (or other spreadsheet file like this): <a href="reef.ods">reef.ods</a>
<li>Convert to CSV in order to be used byb reefree.R: <a href="reef.csv">reef.csv</a>
</ol>

<h3>Using reefree</h3>
<tt>
Rscript reefree.R param [days]
<br>Params help:
<br>all: plot all params
<br>Ca,Kh,Mg: plot Ca, Kh, Mg
<br>Ca: plot Ca
<br>Kh | Mg | NO3 | PO4: plot Kh or Mg or NO3 or PO4
<br>chemist: show recommended chemist ranges
<br>water: display water changes
<br>NO3-PO4: dispersion graph of this params
<br>
<br>Examples:
<br>'Rscript reefree.R Ca': plot Ca for all days
<br>'Rscript reefree.R all 30': plot all params for last 30 days
<br>'Rscript reefree.R all2 90': plot all params (different display) for last 90 days
<br>'Rscript reefree.R water 60': display water changes for last 60 days
</tt>

<strong>For any suggestions or collaborations, write to xaviblas@gmail.com</strong>


<p> The <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. </p>

</body>
</html>
