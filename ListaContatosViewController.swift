//
//  ListaContatosViewController.swift
//  ContatosIP67
//
//  Created by ios7531 on 7/28/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

import UIKit

class ListaContatosViewController: UITableViewController, FormularioContatoViewControllerDelegate {

    var dao: ContatoDAO
    var linhaDestaque: IndexPath?
    static let cellIdentifier = "Cell"

    required init?(coder aDecoder: NSCoder) {
        self.dao = ContatoDAO.sharedInstance()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(exibirMaisAcoes(gesture:)))
        self.tableView.addGestureRecognizer(longPress)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        if let linha = linhaDestaque {
            
            self.tableView.selectRow(at: linha, animated: true, scrollPosition: .middle)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            
            self.tableView.deselectRow(at: linha, animated: true)
            self.linhaDestaque =  .none
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dao.listaTodos().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let contato:Contato = self.dao.buscaContatoNaPosicao(indexPath.row)
        var cell = tableView.dequeueReusableCell(withIdentifier: ListaContatosViewController.cellIdentifier)

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ListaContatosViewController.cellIdentifier)
        }
        // Configure the cell...

        cell!.textLabel?.text = contato.nome
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.dao.remove(indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contatoSelecionado = dao.buscaContatoNaPosicao(indexPath.row)
        self.exibeFormulario(contatoSelecionado)
        
            }
    
    func exibirMaisAcoes(gesture: UIGestureRecognizer){

        let ponto: CGPoint = gesture.location(in: self.tableView)
        
        let indexPath: IndexPath? = self.tableView.indexPathForRow(at: ponto)
        
        let contatoSelecionado = self.dao.buscaContatoNaPosicao(indexPath!.row)
        
        let acoes = GerenciadorDeAcoes(do: contatoSelecionado)
        acoes.exibirAcoes(controller: self)

        
    }

    func exibeFormulario(_ contato: Contato){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let formulario = storyboard.instantiateViewController(withIdentifier: "Form-Contato") as!
        FormularioContatoViewController
        
        formulario.delegate = self
        formulario.contato = contato
        
        self.navigationController?.pushViewController(formulario, animated: true)
        
    }
    
    func contatoAtualizado(_ contato: Contato){
        print("contato atualizado: \(contato.nome)")
    }
    
    func contatoAdicionado(_ contato: Contato){
        print("contato adicionado: \(contato.nome)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FormSegue"{
            if let formulario = segue.destination as? FormularioContatoViewController {
                formulario.delegate = self
            }
    }
    
}
}
