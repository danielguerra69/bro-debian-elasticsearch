<?php
echo exec('tcpdump -r ' . $_GET["pcap_file"] . ' -w - ' . $_GET["proto"] . ' and host '.$_GET["orig_h"] . ' and port ' . $_GET["orig_p"] . ' and host ' . $_GET["resp_h"] . ' and port ' . $_GET["resp_p"]);
?>
