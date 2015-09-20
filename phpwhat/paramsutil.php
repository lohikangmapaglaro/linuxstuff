<?php

class ParamsUtil{
		
			
		
	public static function extractArgs($arr_args){
		$ARGS = array();
		foreach ($arr_args as $arg) {
			if (strpos($arg, '--') === 0) {
				$compspec = explode('=', $arg);
				$key = str_replace('--', '', array_shift($compspec));
				$value = join('=', $compspec);
				$ARGS[$key] = $value;
			}
		}
		
		return $ARGS;
	} 
	
}
