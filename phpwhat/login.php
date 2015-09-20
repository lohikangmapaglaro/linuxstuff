#!/usr/bin/php
<?php




# php login.php --display=singlehead --log=normal --user=walbarda

$class_list = array("user","init","paramsutil");

foreach($class_list as $index => $class_name){
    if(is_readable(dirname(__FILE__) . '/' . strtolower($class_name) . '.php'))
        require(dirname(__FILE__) . '/' . strtolower($class_name) . '.php');
}



$params = ParamsUtil::extractArgs($argv);

$jr = new User;
$jr->login()->load();
$jr->login()->user    = isset($params['user'] 	  ) 	? $params['user'] 		: '';
$jr->login()->display = isset($params['display'] )  		? $params['display'] 	: '';
$jr->login()->log     = isset($params['log'] 	   ) 	? $params['log'] 		: '';

Init::log($jr->login()->log)->loadDisplay($jr->login()->display)->start();

exit(0);
?>
