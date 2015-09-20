<?php



class User{
	
	private $user_properties = array();
	private $properties = array();
	private $active_properties = array();
	private $active_property = '';

	private $logger;
	public function __construct(){
		$this->get_user_properties();
	}
	
	private function get_active_properties(){
		return $this->active_properties;
	}
	
	 public function __set($name, $value){
		if(in_array($name,$this->get_active_properties())){
				$this->properties[$this->active_property][$name] = $value;
		}
    }
	
	public function __get($name){
		if(in_array($name,$this->get_active_properties())){
			return	$this->properties[$this->active_property][$name];
		}
    }
	
	public function _load(){
		$_property = $this->active_property . "_property";
		$this->active_properties = $this->user_properties[$this->active_property][$_property];
	}
	
	public function _save(){
	#	if(isset($this->active_properties)){
	#		$this->active_properties = array();
	#	}

	}
	
	private function get_user_properties(){
		$this->user_properties = array(
			'login' =>  array('login_behaviours' 	=> array('load','new','current'),
							  'login_property' 		=> array('user','display','log'),
							  'login_event'			=> array('on_load','before')
								)
		);
		return $this->user_properties;
	}
	
	public function __call($method, $params){
		if(array_key_exists($method,$this->get_user_properties())){
			$this->active_property = $method;
			return $this;
		}
		foreach ($this->user_properties[$this->active_property] as $properties => $property) {
			if(in_array($method,$property)){
				if(method_exists($this,'_' . $method)){
					$_method = "_" . $method;
					$this->$_method();
					return;
				}
			}
		}
    }	
}

