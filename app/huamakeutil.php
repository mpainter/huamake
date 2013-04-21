<?php
/*
This script contains utility functions for processing HTTP requests.

User supplied data is URL encoded to render text inert in regard to SQL injection and other potential mischief.
*/
function getUrlQStringValue($urlStringName, $returnIfNotSet) {
  if(isset($_GET[$urlStringName]) && $_GET[$urlStringName] != "") {
    return urlencode( $_GET[$urlStringName] ) ;
  } else {
    return $returnIfNotSet;
  }
}

function getUrlPStringValue($urlStringName, $returnIfNotSet) {
  if(isset($_POST[$urlStringName]) && $_POST[$urlStringName] != "") {
    return urlencode( $_POST[$urlStringName] ) ;
  } else {
    return $returnIfNotSet;
  }
}
?>