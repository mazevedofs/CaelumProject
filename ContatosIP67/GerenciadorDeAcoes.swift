//
//  GerenciadorDeAcoes.swift
//  ContatosIP67
//
//  Created by ios7531 on 04/08/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

import Foundation
import UIKit

class GerenciadorDeAcoes: NSObject {
    
    let contato: Contato
    
    var controller: UIViewController!
    
    init(do contato: Contato){
        self.contato = contato
    }
    
    func exibirAcoes(controller: UIViewController){
        self.controller = controller
        
        let alertView = UIAlertController(title: self.contato.nome, message: nil, preferredStyle: .actionSheet)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let ligarParaContato = UIAlertAction(title: "Ligar", style: .default, handler: {
            (action) in
            self.ligar()
            
        })
        
        let exibirContatoNoMapa = UIAlertAction(title: "Abir Mapa", style: .default, handler: { ( action ) in
            
            self.abrirNoMapa()
            
        })
        
        let exibirSiteDoContato = UIAlertAction(title: "Abrir Navegador", style: .default, handler: { ( action ) in
            self.abrirNavegador()
            
        })
        
        let exibirTemperatura = UIAlertAction(title: "Visualizar Clima", style: .default, handler: { ( action ) in
            self.exibirTemperatura()
            
        })
        
        alertView.addAction(cancelar)
        alertView.addAction(ligarParaContato)
        alertView.addAction(exibirContatoNoMapa)
        alertView.addAction(exibirSiteDoContato)
        alertView.addAction(exibirTemperatura)
        
        self.controller.present(alertView, animated: true, completion: nil)
        
    }
    
    private func ligar(){
        let device = UIDevice.current
        
        if device.model == "iPhone" {
            abrirAplicativo(com: "tel" + self.contato.telefone!)
        } else {
            let alert = UIAlertController(title: "Não é possível fazer ligações", message: "Seu disposito não permite chamadas", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil
            )
            
            alert.addAction(action)
            self.controller.present(alert, animated:  true, completion: nil)
        }
    }
    
    private func abrirNoMapa(){
        let url = ("http://maps.google.com/maps?q=" + self.contato.endereco!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if contato.endereco.isEmpty {
            let alert = UIAlertController(title: "Não é possível mostrar o endereço", message: "Contato não tem site cadastrado", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)

            alert.addAction(action)
            
            self.controller.present(alert, animated:  true, completion: nil)
        }else {
            abrirAplicativo(com: url!)
        }
    }
    
    private func abrirNavegador(){
        var url = contato.site!
        if !url.isEmpty {
            if !url.hasPrefix("http://"){
                url = "http://" + url
            }
            abrirAplicativo(com: url)
            
        } else {
            
            let alert = UIAlertController(title: "Não é possível mostrar site", message: "Contato não tem site cadastrado", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            
            self.controller.present(alert, animated:  true, completion: nil)
            
        }
    }
    
    private func abrirAplicativo(com url: String){
        UIApplication
            .shared
                .open(URL(string: url)!, options: [:], completionHandler: nil
        )
    }
    
    func exibirTemperatura(){
        let temperaturaViewController = controller.storyboard?.instantiateViewController(withIdentifier: "temperaturaViewController") as! TemperaturaViewController
        
        temperaturaViewController.contato = self.contato
        
        controller.navigationController?.pushViewController(temperaturaViewController, animated: true)
        
    }
    
}
