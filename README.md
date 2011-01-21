# Restful Cappuccino #

Restful Cappuccino is an easy way to access Ruby on Rails RESTful Web Services. This project use code/ideas from two existing projects CappuccinoResource and CPActiveRecord and add more functionality to make it even more easy and flexible to use.

## How do I use it? ##

I am planning on add an installer but for now it can be downloaded manually to your Frameworks folder. In my case I create a subfolder called RestfulCappuccino and copy the files to it.

Once you have your files in place (I am assuming you put them into Frameworks/RestfulCappuccino) you can import it to your models like this:

	@import <RestfulCappuccino/RestfulCappuccino.j>

## How create a RestfulCappuccino model in Cappuccino ##

	@import <RestfulCappuccino/RestfulCappuccino.j>
	
	@implementation Student : RestfulCappuccino
	{
		
	}

	@end