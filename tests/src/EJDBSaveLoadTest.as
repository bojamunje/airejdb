package
{
	import com.thejustinwalsh.data.EJDB;
	import com.thejustinwalsh.data.EJDBDatabase;
	
	import flash.filesystem.File;
	
	import asunit.framework.TestCase;
	
	public class EJDBSaveLoadTest extends TestCase
	{
		private var now:Date;
		private var db:EJDBDatabase;
		
		public function EJDBSaveLoadTest(testMethod:String=null)
		{
			super(testMethod);
		}
		
		protected override function setUp():void
		{
			now = new Date();
			db = EJDB.open("ejdb-save-load-test", EJDB.JBOWRITER | EJDB.JBOCREAT | EJDB.JBOTRUNC) as EJDBDatabase;
			assertNotNull(db);
			assertNotNull(now);
		}
		
		
		protected override function tearDown():void
		{
			assertNotNull(db);
			db.close();
			
			File.applicationStorageDirectory.resolvePath("ejdb-save-load-test").deleteFile();
		}
		
		public function testSaveLoad():void
		{
			assertNotNull(db);
			assertTrue(db.isOpen);
			
			var parrot1:Object = {
				"name" : "Grenny",
				"type" : "African Grey",
				"male" : true,
				"age" : 1,
				"birthdate" : now,
				"likes" : ["green color", "night", "toys"],
				"extra1" : null
			};
			var parrot2:Object = {
				"name" : "Bounty",
				"type" : "Cockatoo",
				"male" : false,
				"age" : 15,
				"birthdate" : now,
				"likes" : ["sugar cane"],
				"extra1" : null
			};
			
			var oids:Array = db.save("parrots", parrot1, null, parrot2);
			assertNotNull(oids);
			assertEquals(2, oids.length);
			
			// TODO: Need to modify the behaivor to match this test data...
			assertEquals(parrot1["_id"], oids[0]);
			assertEquals(null, oids[1]);
			assertEquals(parrot2["_id"], oids[2]);
			
			//assertEquals(parrot1["_id"], oids[0]);
			//assertEquals(parrot2["_id"], oids[1]);
			
			var parrot2Clone:Object = db.load("parrots", parrot2["_id"]);
			assertNotNull(parrot2Clone);
			assertEquals(parrot2Clone._id, parrot2["_id"]);
			assertEquals(parrot2Clone.name, "Bounty");
		}
	}
}