//
//  Contato.m
//  ContatosIP67
//
//  Created by ios7531 on 7/21/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

#import "Contato.h"

@implementation Contato
    
@dynamic nome, telefone, endereco, site, latitude, longitude, foto;
    
-(NSString *)description {
    return [NSString stringWithFormat: @"Nome: %@, Telefone: %@, Endereço: %@, Site: %@, Latitude: %@, Longitude: %@", self.nome, self.telefone, self.endereco, self.site, self.latitude, self.longitude];
}
    
-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue],
                                      [self.longitude doubleValue]);
}

-(NSString *)title {
    return self.nome;
}
    
-(NSString *)subtitle {
    return self.site;
}


@end
