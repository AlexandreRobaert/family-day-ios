
import UIKit

enum PeriodoBusca {
    case dia
    case semana
    case mes
}

class TarefasDashViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var quantidadesDeTarefas: [String:Int] = [:]
    var periodo: PeriodoBusca = .dia
    var dataInicio: Date = Date()
    var dataFim: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carregarCards()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        let responsavel = Configuration.shared.usuarioResponsavel!
        if responsavel {
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCadastrarTarefa)), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        carregarCards()
    }
    
    @objc func showCadastrarTarefa(){
        navigationController?.pushViewController(CadastrarTarefaViewController(), animated: true)
    }
    
    func ajustarPeriordo(){
        switch periodo {
        case .dia:
            dataInicio = Date()
            dataFim = Date()
        case .semana:
            dataInicio = Date.today().previous(.monday)
            dataFim = Date.today().next(.sunday)
        case .mes:
            dataInicio = Date.today().startOfMonth
            dataFim = Date.today().endOfMonth
        }
    }
    
    @IBAction func mudouPeriodo(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            periodo = .dia
            break
        case 1:
            periodo = .semana
            break
        default:
            periodo = .mes
        }
        carregarCards()
    }
    
    func carregarCards(){
        ajustarPeriordo()
        TarefaDao.getQuantidadesTarefas(dataInicio: dataInicio, dataFim: dataFim) { (quantidades) in
            if let quantidades = quantidades {
                self.quantidadesDeTarefas = quantidades
                self.collectionView.reloadData()
            }
            self.indicator.isHidden = true
        }
    }
    
    
    @IBAction func showCadastroTarefa(_ sender: Any) {
        navigationController?.pushViewController(CadastrarTarefaViewController(), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TarefasTableViewController
        vc.dataInicio = self.dataInicio
        vc.dataFim = self.dataFim
        if let status = sender as? StatusTarefa {
            vc.status = status
        }
    }
}

extension TarefasDashViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quantidadesDeTarefas.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        guard let quantidade = Int(cell.quantidadeLabel.text!) else {return}
        
        if quantidade > 0 {
            var status: StatusTarefa!
            
            switch indexPath.row {
            case 0:
                status = .validacao
                break
            case 1:
                status = .pendente
                break
            case 2:
                status = .aprovado
                break
            case 3:
                status = .reprovado
                break
            case 4:
                status = .refazer
                break
            default:
                status = nil
            }
            
            performSegue(withIdentifier: "segueTarefas", sender: status)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCard", for: indexPath) as! CardCollectionViewCell
        cell.layer.borderWidth = 0.8
        cell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.layer.cornerRadius = 15
        
        switch indexPath.row {
        case 0:
            cell.tituloLabel.text = "Em Aprovação"
            cell.quantidadeLabel.text = quantidadesDeTarefas["validacao"]?.description
            break
        case 1:
            cell.tituloLabel.text = "Á fazer"
            cell.quantidadeLabel.text = quantidadesDeTarefas["pendente"]?.description
            break
        case 2:
            cell.tituloLabel.text = "Feitas"
            cell.quantidadeLabel.text = quantidadesDeTarefas["aprovado"]?.description
            break
        case 3:
            cell.tituloLabel.text = "Reprovadas"
            cell.quantidadeLabel.text = quantidadesDeTarefas["reprovado"]?.description
            break
        case 4:
            cell.tituloLabel.text = "Refazer"
            cell.quantidadeLabel.text = quantidadesDeTarefas["refazer"]?.description
            break
        default:
            cell.tituloLabel.text = "Total"
            cell.quantidadeLabel.text = quantidadesDeTarefas["total"]?.description
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 16
        let spacingBorder:CGFloat = 16
        
        let totalSpacing = (2 * spacingBorder) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}
