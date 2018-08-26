//
//  ContatoDAO.swift
//  ContatosIP67
//
//  Created by ios7531 on 7/21/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ContatoDAO: CoreDataUtil {

    static private var defaultDAO: ContatoDAO!
    var contatos: Array<Contato> = []

    func adiciona(_ contato: Contato) {
        contatos.append(contato)
        
        self.saveContext()
        
        //print(contato)
    }

    static func sharedInstance() -> ContatoDAO {
        if defaultDAO == nil {
            defaultDAO = ContatoDAO()
        }
        
        
        return defaultDAO
    }

    override private init() {
//        self.contatos = Array()
        super.init()
        
        self.inserirDadosInicias()
        
        print("Caminho do BD:\(NSHomeDirectory())")
        
        self.carregaContatos()
    }

    func listaTodos() -> [Contato] {
        return contatos
    }

    func buscaContatoNaPosicao(_ posicao:Int) -> Contato {
        return contatos[posicao]
    }
    
    func remove(_ posicao:Int){
        persistentContainer.viewContext.delete(contatos[posicao])
        contatos.remove(at:posicao)
        
        self.saveContext()
        
    }
    
    func inserirDadosInicias(){
        let configuracoes = UserDefaults.standard
        
        let dadosInseridos = configuracoes.bool(forKey: "dados_inseridos")
        
        if !dadosInseridos {
            let caelumSP = NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext ) as! Contato
            
            caelumSP.nome = "Caelum SP"
            caelumSP.endereco = "São Paulo, SP, Rua Vergueiro, 3185"
            caelumSP.telefone = "01155712751"
            caelumSP.site = "http://www.caelum.com.br"
            caelumSP.latitude = -23.5883034
            caelumSP.longitude = -46.632369
        
            self.saveContext()
            
            configuracoes.set(true, forKey: "dados_inseridos")
            
            configuracoes.synchronize()
        
        }
    }
    
    func carregaContatos(){
        let busca = NSFetchRequest<Contato>(entityName: "Contato")
        
        let orderPorNome = NSSortDescriptor(key: "nome", ascending: true)
        
        busca.sortDescriptors = [orderPorNome]
        
        do {
            self.contatos = try self.persistentContainer.viewContext.fetch(busca)
        }catch let error as NSError {
            print("Fetch falhou: \(error.localizedDescription)")
        }
    }
    
    func novoContato() -> Contato {
        return NSEntityDescription.insertNewObject(forEntityName: "Contato", into: self.persistentContainer.viewContext) as! Contato
    }

}
