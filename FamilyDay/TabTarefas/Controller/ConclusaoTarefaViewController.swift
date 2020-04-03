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
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var concluirTarefaButton: UIButton!
    @IBOutlet weak var comentarioTextField: UITextField!
    
    let responsavel = Configuration.shared.usuarioResponsavel!
    var tarefa: Tarefa!
    var historicoSelecionado: Historico!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellFoto")
        configUI()
    }
    
    func configUI(){
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
        case StatusTarefa.pendente.rawValue.uppercased():
            status = "Pendente"
        case StatusTarefa.aprovado.rawValue.uppercased():
            status = "Aprovado"
        case StatusTarefa.reprovado.rawValue.uppercased():
            status = "Reprovado"
        case StatusTarefa.refazer.rawValue.uppercased():
            status = "Refazer"
        default:
            print(status)
        }
        
        statusHistorico.text = "Status: \(status)"
        cameraButton.isHidden = true
        concluirTarefaButton.isHidden = true
        stackBotoes.isHidden = true
        
        if !responsavel && (historicoSelecionado.status == StatusTarefa.pendente.rawValue.uppercased() || historicoSelecionado.status == StatusTarefa.refazer.rawValue.uppercased()) {
            cameraButton.isHidden = false
            concluirTarefaButton.isHidden = false
        }else if responsavel && historicoSelecionado.status == StatusTarefa.validacao.rawValue.uppercased() {
            stackBotoes.isHidden = false
        }
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
    
    @IBAction func concluirTarefa(_ sender: Any) {
        historicoSelecionado.status = StatusTarefa.validacao.rawValue.uppercased()
        historicoSelecionado.comentario = comentarioTextField.text!
        TarefaDao.atualizarTarefa(historico: historicoSelecionado, idTarefa: tarefa.id) { (sucesso) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension ConclusaoTarefaViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellFoto", for: indexPath) as! FotoCollectionViewCell
        cell.foto.image = #imageLiteral(resourceName: "avatar")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tamanho = (view.frame.width / 3) - 20
        
        return CGSize(width: tamanho, height: tamanho)
    }
}
