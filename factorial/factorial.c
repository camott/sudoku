int factorial(int x){
	if(x == 1 || x == 0) {
		return 1;
	} else if(x < 0) {
		//no exceptions, assume -1 means error
		return -1;
	} else {
		return x * factorial(x - 1);
	}
}