<?php
$command="/usr/sbin/tcpdump -r ". $_GET["pcap_file"] . ' -w - ' . $_GET["proto"] . ' and host '.$_GET["orig_h"] . ' and port ' . $_GET["orig_p"] . ' and host ' . $_GET["resp_h"] . ' and port ' . $_GET["resp_p"];
$filename = $_GET["proto"]."-".$_GET["orig_h"].":".$_GET["orig_p"]."x".$_GET["resp_h"].":".$_GET["resp_p"];
header("Content-Disposition: attachment; filename=\"$filename.pcap\"");
header("Content-Type:application/octet-stream");
$contents = shell_exec($command);
header('Content-Length: '.strlen($contents));
print $contents;
?>
