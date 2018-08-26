//
//  FormularioContatoViewControllerDelegate.swift
//  ContatosIP67
//
//  Created by ios7531 on 28/07/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

import Foundation

protocol FormularioContatoViewControllerDelegate {
    func contatoAtualizado(_ contato: Contato)
    func contatoAdicionado(_ contato: Contato)
}
