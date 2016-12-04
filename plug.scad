//TODO 2-manyfold
//DONE zásuvka se stejnými parametry ale rozdílným round_r bude mít po xové ose stejný rozměr


module zaklad (number_of_outlets,posun,full,z){
    for (i=[0:number_of_outlets-1]){
        translate([posun*i,0,0]) {
            cylinder(h=z, r=full, center=true);
            //první jinak
            if (i==0)  { 
            translate([-full/2,0,0]) 
                cube(size = [full,2*full,z], center = true);
            }  
        }  
    }
}

module plug(
	y=40,
	z=30,
	radius_of_outlets = 15,
	number_of_outlets = 3,
	border_of_outlet = 6,
	offset_of_outlets = 0,
	depth_of_outlets = 10,
	pin_radius = 2,
	pin_depth = 5,
	pin_offset = 8,
	pin_angle = 45,
	round_r =2){
	
	//pomocné výpočty a proměnné
	full = radius_of_outlets + border_of_outlet;
	posun = radius_of_outlets * 2 + offset_of_outlets;
	x = posun * (number_of_outlets - 1) + 2 * (radius_of_outlets + border_of_outlet);
	realY = y - round_r;
	realZ = z - round_r;
	odchylka=0.01;
	pinnStart = realZ/2 - depth_of_outlets + round_r ;
	//vycentrovani= radius_of_outlets + border_of_outlet;
	vycentrovani= offset_of_outlets /2 + radius_of_outlets - posun * number_of_outlets / 2;
		
	//omezit hodnoty a kdyžtak throw IllegalArgumentException
	if (y<radius_of_outlets ){echo("Chybný argument !!! -1");}
	else if	(depth_of_outlets+pin_depth>=z ){echo("Chybný argument !!! -2");}
	else if	(z<0 ){echo("Chybný argument !!! -3");}
	else if	(number_of_outlets<=0 ){echo("Chybný argument !!! -4");}
	else if	(border_of_outlet<=0 ){echo("Chybný argument !!! -5");}
	else if	(offset_of_outlets<0){echo("Chybný argument !!! -6");}
	else{
		//nastavení odchylky kvůli 2-manifold
		if (offset_of_outlets==0) {
			echo("FFFFFFFFFF, offset_of_outlets=", offset_of_outlets);
			offset_of_outlets = odchylka;
			
			//vycentrovat
			translate([vycentrovani,0,z/2]){
				difference() {
					difference() {
						//zaoblení
						minkowski(){
							//oříznutí
							intersection(){
								//základ
								zaklad(number_of_outlets,posun,full,realZ);
								translate([x/2-full,0,0]){
									cube(size = [x - 2 * round_r,realY - round_r, realZ - round_r], center = true);
								}
							}
							sphere(r = round_r);
						}
						//díry
						for (i=[0:number_of_outlets-1]){
							translate([posun*i,0,(z-depth_of_outlets+round_r)/2]){
								cylinder(h=depth_of_outlets, r=radius_of_outlets, center=true);
							}
						}
					}
					//piny zapustěné
					for (i=[0:number_of_outlets-1]){
						translate([posun*i,0, pinnStart]){
							rotate(a = -pin_angle, v = [0, 0, 1]) {
								translate([-pin_offset,0,-pin_depth/2])
									cylinder(h=pin_depth, r=pin_radius, center=true);
								translate([pin_offset,0,-pin_depth/2])
									cylinder(h=pin_depth, r=pin_radius, center=true);
							}
						}
					}
				}
				//piny koukající
				for (i=[0:number_of_outlets-1]){
					translate([posun*i,0, pinnStart]){
						rotate(a = -pin_angle, v = [0, 0, 1]) {
							translate([0,pin_offset,pin_depth/2])
								color("blue") cylinder(h=pin_depth, r=pin_radius, center=true);
						}
					}
				}
			}
		}else{
			//vycentrovat
			translate([vycentrovani,0,z/2]){
				difference() {
					difference() {
						//zaoblení
						minkowski(){
							//oříznutí
							intersection(){
								//základ
								zaklad(number_of_outlets,posun,full,realZ);
								translate([x/2-full,0,0]){
									cube(size = [x - 2 * round_r,realY - round_r, realZ - round_r], center = true);
								}
							}
							sphere(r = round_r);
						}
						//díry
						for (i=[0:number_of_outlets-1]){
							translate([posun*i,0,(z-depth_of_outlets+round_r)/2]){
								cylinder(h=depth_of_outlets, r=radius_of_outlets, center=true);
							}
						}
					}
					//piny zapustěné
					for (i=[0:number_of_outlets-1]){
						translate([posun*i,0, pinnStart]){
							rotate(a = -pin_angle, v = [0, 0, 1]) {
								translate([-pin_offset,0,-pin_depth/2])
									cylinder(h=pin_depth, r=pin_radius, center=true);
								translate([pin_offset,0,-pin_depth/2])
									cylinder(h=pin_depth, r=pin_radius, center=true);
							}
						}
					}
				}
				//piny koukající
				for (i=[0:number_of_outlets-1]){
					translate([posun*i,0, pinnStart]){
						rotate(a = -pin_angle, v = [0, 0, 1]) {
							translate([0,pin_offset,pin_depth/2])
								color("blue") cylinder(h=pin_depth, r=pin_radius, center=true);
						}
					}
				}
			}
		}
	}
}
//plug();
