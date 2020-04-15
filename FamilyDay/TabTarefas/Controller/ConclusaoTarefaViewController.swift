//
//  ConclusaoTarefaViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 01/04/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class ConclusaoTarefaViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackBotoes: UIStackView!
    @IBOutlet weak var tituloTarefa: UILabel!
    @IBOutlet weak var descricaoTarefa: UILabel!
    @IBOutlet weak var dataExecucaoHistorico: UILabel!
    @IBOutlet weak var statusHistorico: UILabel!
    @IBOutlet weak var concluirTarefaButton: UIButton!
    @IBOutlet weak var comentarioTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    let responsavel = Configuration.shared.usuarioResponsavel!
    var tarefa: Tarefa!
    var historicoSelecionado: Historico!
    var fotoController: UIImagePickerController!
    var imagens: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellFoto")
        configUI()
        carregarFotos()
    }
    
    func configUI(){
        indicator.isHidden = true
        let formatData = DateFormatter()
        formatData.dateFormat = "dd/MM/yyyy"
        tituloTarefa.text = tarefa.titulo
        descricaoTarefa.text = tarefa.descricao
        dataExecucaoHistorico.text = "Data: \(formatData.string(from: historicoSelecionado.dataExecucao))"
        comentarioTextField.text = historicoSelecionado.comentario
        
        var status = " "
        
        switch historicoSelecionado.status {
        case StatusTarefa.validacao.rawValue.uppercased():
            status = "Aguardando aprovação"
            break
        case StatusTarefa.pendente.rawValue.uppercased():
            status = "Pendente"
            break
        case StatusTarefa.aprovado.rawValue.uppercased():
            status = "Aprovado"
            break
        case StatusTarefa.reprovado.rawValue.uppercased():
            status = "Reprovado"
            break
        case StatusTarefa.refazer.rawValue.uppercased():
            status = "Refazer"
            break
        default:
            print(status)
        }
        
        statusHistorico.text = "Status: \(status)"
        concluirTarefaButton.isHidden = true
        stackBotoes.isHidden = true
        
        if !responsavel && (historicoSelecionado.status == StatusTarefa.pendente.rawValue.uppercased() || historicoSelecionado.status == StatusTarefa.refazer.rawValue.uppercased()) {
            concluirTarefaButton.isHidden = false
            
        }else if responsavel && historicoSelecionado.status == StatusTarefa.validacao.rawValue.uppercased() {
            stackBotoes.isHidden = false
        }
    }
    
    func tirarFoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            fotoController = UIImagePickerController()
            fotoController.sourceType = .camera
            fotoController.delegate = self
            present(fotoController, animated: true, completion: nil)
        }else{
            let actionController = UIAlertController(title: "Câmera indisponível", message: "Não encontramos a câmera do seu telefone", preferredStyle: .alert)
            actionController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(actionController, animated: true)
        }
    }
    
    func carregarFotos(){
        indicator.isHidden = false
        for url in historicoSelecionado.fotos {
            FirebaseDao.downloadImagen(forUrl: url) { (image) in
                if let image = image {
                    self.imagens.append(image)
                }
                self.collectionView.reloadData()
            }
        }
        indicator.isHidden = true
    }
    
    @IBAction func aceitarReprovarRefazerTarefa(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            historicoSelecionado.status = StatusTarefa.aprovado.rawValue
        case 1:
            historicoSelecionado.status = StatusTarefa.reprovado.rawValue
        default:
            historicoSelecionado.status = StatusTarefa.refazer.rawValue
        }
        historicoSelecionado.comentario = comentarioTextField.text!
        TarefaDao.atualizarTarefa(historico: historicoSelecionado, idTarefa: tarefa.id) { (sucesso) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func fazerUploadDasImagensEConcluirTarefa(){
        FirebaseDao.uploadImagens(idTarefa: tarefa.id, numeroDaFoto: 1, imagem: imagens[0]) { (urlDownload) in
            if let url = urlDownload {
                self.historicoSelecionado.fotos.append(url)
                FirebaseDao.uploadImagens(idTarefa: self.tarefa.id, numeroDaFoto: 2, imagem: self.imagens[1]) { (urlDownload) in
                    if let url = urlDownload {
                        self.historicoSelecionado.fotos.append(url)
                        FirebaseDao.uploadImagens(idTarefa: self.tarefa.id, numeroDaFoto: 3, imagem: self.imagens[2]) { (urlDownload) in
                            if let url = urlDownload {
                                self.historicoSelecionado.fotos.append(url)
                                self.indicator.isHidden = true
                                
                                self.historicoSelecionado.status = StatusTarefa.validacao.rawValue.uppercased()
                                self.historicoSelecionado.comentario = self.comentarioTextField.text!
                                TarefaDao.atualizarTarefa(historico: self.historicoSelecionado, idTarefa: self.tarefa.id) { (sucesso) in
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func concluirTarefa(_ sender: Any) {
        concluirTarefaButton.isEnabled = false
        indicator.isHidden = false
        
        if imagens.count == 3 && tarefa.exigeComprovacao {
            fazerUploadDasImagensEConcluirTarefa()
        }else{
            //Fazer alguma coisa
        }
        
    }
}

extension ConclusaoTarefaViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFoto", for: indexPath) as! FotoCollectionViewCell
        cell.botaoCamera.isHidden = true
        
        if !imagens.isEmpty && imagens.count > indexPath.row {
            cell.foto.image = imagens[indexPath.row]
        }else{
            cell.foto.image = #imageLiteral(resourceName: "avatar")
        }
        if !responsavel && (historicoSelecionado.status == StatusTarefa.pendente.rawValue.uppercased() || historicoSelecionado.status == StatusTarefa.refazer.rawValue.uppercased()) {
            cell.botaoCamera.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !responsavel {
            tirarFoto()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tamanho = (view.frame.width / 3) - 20
        
        return CGSize(width: tamanho, height: tamanho)
    }
}

extension ConclusaoTarefaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageResize = Utils.resizedImage(at: image, for: CGSize(width: 300.0, height: 300.0))
        imagens.append(imageResize)
        collectionView.reloadData()
        fotoController.dismiss(animated: true, completion: nil)
    }
}
