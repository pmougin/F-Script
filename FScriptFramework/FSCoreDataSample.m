/* FSCoreDataSample.m Copyright (c) 2005-2006 Philippe Mougin.  */
/*   This software is open source. See the licence.  */  

#import "FSCoreDataSample.h"

@implementation FSCoreDataSample

+ managedObject
{
  NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
  NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] init];
  
  NSEntityDescription *employeeEntity = [[[NSEntityDescription alloc] init] autorelease];
  [employeeEntity setName:@"employee"];
  [employeeEntity setManagedObjectClassName:@"NSManagedObject"]; 
    
  NSEntityDescription *departmentEntity = [[[NSEntityDescription alloc] init] autorelease];
  [departmentEntity setName:@"department"];
  [departmentEntity setManagedObjectClassName:@"Department"];
  
  NSAttributeDescription *nameAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [nameAttribute setName:@"name"];
  [nameAttribute setAttributeType:NSStringAttributeType];
  
  NSAttributeDescription *budgetAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [budgetAttribute setName:@"budget"];
  [budgetAttribute setAttributeType:NSInteger32AttributeType];
  
  NSRelationshipDescription *employeesRelationship = [[[NSRelationshipDescription alloc] init] autorelease];
  [employeesRelationship setName:@"employees"];
  [employeesRelationship setDestinationEntity:employeeEntity];
  [employeesRelationship setMinCount:0];
  [employeesRelationship setMaxCount:999];
 
  NSAttributeDescription *firstNameAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [firstNameAttribute setName:@"firstName"];
  [firstNameAttribute setAttributeType:NSStringAttributeType];
  [firstNameAttribute setDefaultValue:@""];
  
  NSAttributeDescription *lastNameAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [lastNameAttribute setName:@"lastName"];
  [lastNameAttribute setAttributeType:NSStringAttributeType];
  [lastNameAttribute setDefaultValue:@""];
  
  NSAttributeDescription *salaryAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [salaryAttribute setName:@"salary"];
  [salaryAttribute setAttributeType:NSInteger32AttributeType];
    
  NSAttributeDescription *phoneAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [phoneAttribute setName:@"phone"];
  [phoneAttribute setAttributeType:NSStringAttributeType];
  
  NSAttributeDescription *emailAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [emailAttribute setName:@"email"];
  [emailAttribute setAttributeType:NSStringAttributeType];
  
  NSAttributeDescription *addressAttribute = [[[NSAttributeDescription alloc] init] autorelease];
  [addressAttribute setName:@"address"];
  [addressAttribute setAttributeType:NSStringAttributeType];


  NSRelationshipDescription *managerRelationship = [[[NSRelationshipDescription alloc] init] autorelease];
  [managerRelationship setName:@"manager"];
  [managerRelationship setDestinationEntity:employeeEntity];
  [managerRelationship setMinCount:0];
  [managerRelationship setMaxCount:1];
  
  NSRelationshipDescription *directReportsRelationship = [[[NSRelationshipDescription alloc] init] autorelease];
  [directReportsRelationship setName:@"directReports"];
  [directReportsRelationship setDestinationEntity:employeeEntity];
  [directReportsRelationship setMinCount:0];
  [directReportsRelationship setMaxCount:99];   
  
  NSRelationshipDescription *departmentRelationship = [[[NSRelationshipDescription alloc] init] autorelease];
  [departmentRelationship setName:@"department"];
  [departmentRelationship setDestinationEntity:departmentEntity];
  [departmentRelationship setMinCount:0];
  [departmentRelationship setMaxCount:1];

  [managerRelationship setInverseRelationship:directReportsRelationship];
  [directReportsRelationship setInverseRelationship:managerRelationship];
  
  [departmentRelationship setInverseRelationship:employeesRelationship];
  [employeesRelationship setInverseRelationship:departmentRelationship];

  [employeeEntity setProperties:[NSArray arrayWithObjects:firstNameAttribute, lastNameAttribute, salaryAttribute, phoneAttribute, emailAttribute, addressAttribute, managerRelationship, directReportsRelationship, departmentRelationship, nil]];
  [departmentEntity setProperties:[NSArray arrayWithObjects:nameAttribute, budgetAttribute, employeesRelationship, nil]];

  NSArray *entities = [NSArray arrayWithObjects:departmentEntity, employeeEntity, nil];
  
  [objectModel setEntities:entities];

  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
  
  [context setPersistentStoreCoordinator:coordinator];

  NSManagedObject *department1 = [[[NSManagedObject alloc] initWithEntity:departmentEntity insertIntoManagedObjectContext:context] autorelease];
  [department1 setValue:@"R&D" forKey:@"name"]; 
  [department1 setValue:[NSNumber numberWithInt:450000] forKey:@"budget"]; 

  NSManagedObject *department2 = [[[NSManagedObject alloc] initWithEntity:departmentEntity insertIntoManagedObjectContext:context] autorelease];
  [department2 setValue:@"Sales" forKey:@"name"]; 
  [department2 setValue:[NSNumber numberWithInt:575000] forKey:@"budget"]; 

  NSManagedObject *department3 = [[[NSManagedObject alloc] initWithEntity:departmentEntity insertIntoManagedObjectContext:context] autorelease];
  [department3 setValue:@"Support" forKey:@"name"]; 
  [department3 setValue:[NSNumber numberWithInt:10000] forKey:@"budget"]; 

  NSManagedObject *department4 = [[[NSManagedObject alloc] initWithEntity:departmentEntity insertIntoManagedObjectContext:context] autorelease];
  [department4 setValue:@"Marketing" forKey:@"name"]; 
  [department4 setValue:[NSNumber numberWithInt:110000] forKey:@"budget"]; 
   
  NSManagedObject *employee1 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee1 setValue:@"John" forKey:@"firstName"];
  [employee1 setValue:@"Smith" forKey:@"lastName"];
  [employee1 setValue:[NSNumber numberWithInt:3000] forKey:@"salary"];
  [employee1 setValue:@"jsmith@supercool.com" forKey:@"email"];
  [employee1 setValue:@"08 65 424" forKey:@"phone"];
  [employee1 setValue:@"9 Lupo Place, 74986 Coolville" forKey:@"address"];

  NSManagedObject *employee2 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee2 setValue:@"Jean-Louis" forKey:@"firstName"];
  [employee2 setValue:@"Langlois" forKey:@"lastName"];
  [employee2 setValue:[NSNumber numberWithInt:3700] forKey:@"salary"];
  [employee2 setValue:@"jllanglois@supercool.com" forKey:@"email"];
  [employee2 setValue:@"04 56 896" forKey:@"phone"];
  [employee2 setValue:@"7 Bleker Street, 74986 Coolville" forKey:@"address"];

  NSManagedObject *employee3 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee3 setValue:@"Henri" forKey:@"firstName"];
  [employee3 setValue:@"Carter" forKey:@"lastName"];
  [employee3 setValue:[NSNumber numberWithInt:3800] forKey:@"salary"];
  [employee3 setValue:@"hcarter@supercool.com" forKey:@"email"];
  [employee3 setValue:@"04 55 654" forKey:@"phone"];
  [employee3 setValue:@"850 Bleker Street, 74986 Coolville" forKey:@"address"];
  
  NSManagedObject *employee4 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee4 setValue:@"Fred" forKey:@"firstName"];
  [employee4 setValue:@"Fonda" forKey:@"lastName"];
  [employee4 setValue:[NSNumber numberWithInt:4300] forKey:@"salary"];
  [employee4 setValue:@"ffonda@supercool.com" forKey:@"email"];
  [employee4 setValue:@"02 76 654" forKey:@"phone"];
  [employee4 setValue:@"23 Roma Street, 40538 Fairyville" forKey:@"address"];
  
  NSManagedObject *employee5 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee5 setValue:@"Phil" forKey:@"firstName"];
  [employee5 setValue:@"Berry" forKey:@"lastName"];
  [employee5 setValue:[NSNumber numberWithInt:2200] forKey:@"salary"];
  [employee5 setValue:@"pberry@supercool-uk.com" forKey:@"email"];
  [employee5 setValue:@"04 98 652" forKey:@"phone"];
  [employee5 setValue:@"6 Panda Street, 40538 Fairyville" forKey:@"address"];
  
  NSManagedObject *employee6 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee6 setValue:@"Eric" forKey:@"firstName"];
  [employee6 setValue:@"Bill" forKey:@"lastName"];
  [employee6 setValue:[NSNumber numberWithInt:4000] forKey:@"salary"];
  [employee6 setValue:@"ebill@supercool-uk.com" forKey:@"email"];
  [employee6 setValue:@"04 56 896" forKey:@"phone"];
  [employee6 setValue:@"67 Cool Street, 74986 Coolville" forKey:@"address"];

  NSManagedObject *employee7 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee7 setValue:@"Hannah" forKey:@"firstName"];
  [employee7 setValue:@"Mig" forKey:@"lastName"];
  [employee7 setValue:[NSNumber numberWithInt:3750] forKey:@"salary"];
  [employee7 setValue:@"hmig@supercool.com" forKey:@"email"];
  [employee7 setValue:@"02 76 109" forKey:@"phone"];
  [employee7 setValue:@"34 Super Street, 40538 Fairyville" forKey:@"address"];

  NSManagedObject *employee8 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee8 setValue:@"Suzan" forKey:@"firstName"];
  [employee8 setValue:@"Mina" forKey:@"lastName"];
  [employee8 setValue:[NSNumber numberWithInt:3550] forKey:@"salary"];
  [employee8 setValue:@"webmaster@supercool.com" forKey:@"email"];
  [employee8 setValue:@"05 45 123" forKey:@"phone"];
  [employee8 setValue:@"70 Quality Street, 74986 Coolville" forKey:@"address"];
  
  NSManagedObject *employee9 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee9 setValue:@"Irene" forKey:@"firstName"];
  [employee9 setValue:@"French" forKey:@"lastName"];
  [employee9 setValue:[NSNumber numberWithInt:3200] forKey:@"salary"];
  [employee9 setValue:@"ifrench@supercool.com" forKey:@"email"];
  [employee9 setValue:@"04 56 875" forKey:@"phone"];
  [employee9 setValue:@"953 Long Street, 40538 Fairyville" forKey:@"address"];

  NSManagedObject *employee10 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee10 setValue:@"Alan" forKey:@"firstName"];
  [employee10 setValue:@"Peer" forKey:@"lastName"];
  [employee10 setValue:[NSNumber numberWithInt:3000] forKey:@"salary"];
  [employee10 setValue:@"apeer@supercool.com" forKey:@"email"];
  [employee10 setValue:@"04 56 100" forKey:@"phone"];
  [employee10 setValue:@"1 Short Street, 40538 Fairyville" forKey:@"address"];
  
  NSManagedObject *employee11 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee11 setValue:@"Daniel" forKey:@"firstName"];
  [employee11 setValue:@"Wylde" forKey:@"lastName"];
  [employee11 setValue:[NSNumber numberWithInt:3900] forKey:@"salary"];
  [employee11 setValue:@"dwylde@supercool.com" forKey:@"email"];
  [employee11 setValue:@"04 34 982" forKey:@"phone"];
  [employee11 setValue:@"76 Cocoa Place, 74986 Coolville" forKey:@"address"];
  
  NSManagedObject *employee12 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee12 setValue:@"Brett" forKey:@"firstName"];
  [employee12 setValue:@"Sinclair" forKey:@"lastName"];
  [employee12 setValue:[NSNumber numberWithInt:3000] forKey:@"salary"];
  [employee12 setValue:@"bsinclair@supercool.com" forKey:@"email"];
  [employee12 setValue:@"04 51 221" forKey:@"phone"];
  [employee12 setValue:@"211 Salon Street, 40538 Fairyville" forKey:@"address"];

  NSManagedObject *employee13 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee13 setValue:@"Britany" forKey:@"firstName"];
  [employee13 setValue:@"Holder" forKey:@"lastName"];
  [employee13 setValue:[NSNumber numberWithInt:3400] forKey:@"salary"];
  [employee13 setValue:@"bholder@supercool.com" forKey:@"email"];
  [employee13 setValue:@"01 23 432" forKey:@"phone"];
  [employee13 setValue:@"21 Life Street, 03242 Aloa" forKey:@"address"];
  
  NSManagedObject *employee14 = [[[NSManagedObject alloc] initWithEntity:employeeEntity insertIntoManagedObjectContext:context] autorelease];
  [employee14 setValue:@"Angela" forKey:@"firstName"];
  [employee14 setValue:@"Lucidi" forKey:@"lastName"];
  [employee14 setValue:[NSNumber numberWithInt:3800] forKey:@"salary"];
  [employee14 setValue:@"alucidi@supercool.com" forKey:@"email"];
  [employee14 setValue:@"04 87 336" forKey:@"phone"];
  [employee14 setValue:@"9 Rich Street, 03242 Aloa" forKey:@"address"];
   
  [employee1 setValue:employee2 forKey:@"manager"];
  [employee1 setValue:department1 forKey:@"department"];

  [employee2 setValue:department1 forKey:@"department"];

  [employee3 setValue:employee2 forKey:@"manager"];
  [employee3 setValue:department1 forKey:@"department"];
  
  [employee4 setValue:employee2 forKey:@"manager"];
  [employee4 setValue:department1 forKey:@"department"];

  [employee5 setValue:employee2 forKey:@"manager"];
  [employee5 setValue:department1 forKey:@"department"];
  
  [employee6 setValue:department2 forKey:@"department"];
  
  [employee7 setValue:employee6 forKey:@"manager"];
  [employee7 setValue:department2 forKey:@"department"];

  [employee8 setValue:employee6 forKey:@"manager"];
  [employee8 setValue:department2 forKey:@"department"];

  [employee9 setValue:employee6 forKey:@"manager"];
  [employee9 setValue:department3 forKey:@"department"];
  
  [employee10 setValue:department4 forKey:@"department"];

  [employee11 setValue:employee10 forKey:@"manager"];
  [employee11 setValue:department4 forKey:@"department"];

  [employee12 setValue:employee11 forKey:@"manager"];
  [employee12 setValue:department4 forKey:@"department"];
  
  [employee13 setValue:employee2 forKey:@"manager"];
  [employee13 setValue:department1 forKey:@"department"];

  [employee14 setValue:employee11 forKey:@"manager"];
  [employee14 setValue:department4 forKey:@"department"];

  return employee2;  
}


@end
