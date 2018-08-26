//
//  Contato.h
//  ContatosIP67
//
//  Created by ios7531 on 7/21/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreData/CoreData.h>

@interface Contato : NSManagedObject <MKAnnotation>
    
@property (strong) NSString *nome;
@property (strong) NSString *telefone;
@property (strong) NSString *endereco;
@property (strong) NSString *site;
@property (strong) UIImage *foto;
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;
    
@end
