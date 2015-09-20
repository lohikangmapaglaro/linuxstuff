<?php

class Init{

	private static $startX;


	public static function log($log) {
		switch($log) {
			case 'normal':
				exec("sed -i.bak '/.*shmlog*./c\ exec i3' ~/.xinitrc");
				self::$startX = "startx";
				break;

			case 'verbose':
				exec("sed -i.bak '/.*exec i3*./c\ exec i3 -V  --shmlog-size=26214400 >> ~/.i3.log 2>&1' ~/.xinitrc");
				self::$startX = "startx -- -keeptty > ~/.xorg.log 2>&1";
				break;

			default:
				break;
		}
	return new self;
	}




	public function loadDisplay($display) {
		switch($display) {
			case 'singlehead':
				exec ("sed -i.bak 's/4160x900/1366x768/' ~/.xinitrc");
				exec("cp ~/.config/i3/config.single ~/.config/i3/config");
				exec ("sudo cp /etc/X11/xorg.conf.single /etc/X11/xorg.conf");
				break;
			case 'multihead':
				exec ("sed -i.bak 's/1366x768/4160x900/'  ~/.xinitrc");
				exec("cp ~/.config/i3/config.multi ~/.config/i3/config");
				exec ("sudo cp /etc/X11/xorg.conf.multi /etc/X11/xorg.conf");

				break;
			case 'headless':
				exec ("sed -i.bak 's/4160x900/1366x768/' ~/.xinitrc");
				break;
			
			default:
				break;
		}

		return $this;
	}


	public static function start() {
		 exec(self::$startX);
	}

}

