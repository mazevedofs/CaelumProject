//
//  ViewController.swift
//  ContatosIP67
//
//  Created by ios7531 on 7/21/18.
//  Copyright © 2018 ios7531. All rights reserved.
//

import UIKit
import CoreLocation

class FormularioContatoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var nome:     UITextField!
    @IBOutlet var telefone: UITextField!
    @IBOutlet var endereco: UITextField!
    @IBOutlet var site:     UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var dao: ContatoDAO
    var contato: Contato!
    var delegate: FormularioContatoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selecionarFoto(sender:)))
        
        self.imageView.addGestureRecognizer(tap)
        

        if contato != nil {
            self.nome.text = contato.nome
            self.telefone.text = contato.telefone
            self.endereco.text = contato.endereco
            self.site.text = contato.site
            self.latitude.text = contato.latitude?.description
            self.longitude.text = contato.longitude?.description
            
            if let foto  = self.contato.foto {
                self.imageView.image = foto
            }
            
            let botaoAlterar = UIBarButtonItem(title: "Confirmar", style: .plain, target: self, action: #selector (atualizaContato))
            
            self.navigationItem.rightBarButtonItem = botaoAlterar
            
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        imageView.layer.cornerRadius = imageView.frame.width / 2
//        imageView.layer.masksToBounds = true

        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init(coder aDecoder: NSCoder) {
        self.dao = ContatoDAO.sharedInstance()
        super.init(coder: aDecoder)!
    }

    func pegaDadosDoFormulario() {
        if contato == nil {
            self.contato = dao.novoContato()
        }

        self.contato.nome = self.nome.text!
        self.contato.telefone = self.telefone.text!
        self.contato.endereco = self.endereco.text!
        self.contato.site = self.site.text!
        self.contato.foto = self.imageView.image
        
        if let latitude = Double(self.latitude.text!) {
            self.contato.latitude = latitude as NSNumber
        }
        
        if let longitude = Double(self.longitude.text!) {
            self.contato.longitude = longitude as NSNumber
        }
    }
    
    func atualizaContato(){
        pegaDadosDoFormulario()
        
        self.delegate?.contatoAtualizado(contato)
        
        ContatoDAO.sharedInstance().saveContext()
        
        popNavigation()
        
    }

    func popNavigation() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buscarCoordenadas(_ sender: UIButton) {
        
        self.loading.startAnimating()
        sender.isEnabled = false
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self.endereco.text!) { (resultado, error) in
     
            if error == nil && (resultado?.count)! > 0 {
                let placemark  = resultado![0]
                let coordenada = placemark.location!.coordinate
                
                self.latitude.text = coordenada.latitude.description
                self.longitude.text = coordenada.longitude.description
                
            }
            
        self.loading.stopAnimating()
        sender.isEnabled = true
            
        }
    }
    
    @IBAction func criaContato() {
        self.pegaDadosDoFormulario()
        dao.adiciona(contato)
        
        self.delegate?.contatoAdicionado(contato)
        
        popNavigation()
    }
    
    func selecionarFoto(sender: AnyObject){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
        } else {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagemSelecionada = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = imagemSelecionada
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

