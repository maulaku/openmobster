/**
 * Copyright (c) {2003,2010} {openmobster@gmail.com} {individual contributors as indicated by the @authors tag}.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

#import <Foundation/Foundation.h>
#import "Context.h"
#import "ActionHandler.h"
#import "DecisionHandler.h"
#import "GenericAttributeManager.h"


@interface Node : NSObject 
{
	@private
	NSString *name;
	NSString *activeTransition;
	id handler;
	BOOL isRoot;
}

+(id) withInit;

@property (assign) NSString *name;
@property (assign) NSString *activeTransition;
@property (assign) id handler;
@property (assign) BOOL isRoot;

-(void) process:(Context *) context;

@end
