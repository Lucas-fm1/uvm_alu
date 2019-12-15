extern "C" int my_alu(int a, int b, int op){
	switch(op){
		case 0:
			return a + b;
		//------------------//
		case 1:				
			if(a > b)
				return a - b;
			else
				return b - a;
		//------------------//
		case 2:
			return a + 1;
		//------------------//
		case 3:
			return b + 1;
		//------------------//
		default:
			return 0;
	}
}