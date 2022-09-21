//
//  FollowerListViewController.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 8/7/22.
//

import UIKit



class FollowerListViewController: GFDataLoadingVC {
    
    enum Section{
        case main
    }
    
    var username: String!
    var follower:[Follower] = []
    var filteredFollower:[Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String){
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
//        searchController.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func getFollowers(username:String, page:Int){
        showLoadingView()
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self ] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()

            switch result{
                
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.follower.append(contentsOf: followers)
                
                if self.follower.isEmpty{
                    let message = "This user does not have any follower. Go follow them 😁."
                    DispatchQueue.main.async {self.showEmptyStateView(with: message, in: self.view)}
                    return
                }
                
                self.updateData(for: self.follower)
                
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    func configureDataSource(){
        datasource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(for follower: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(follower)
        DispatchQueue.main.async { 
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result{
                
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    
                    guard let error = error else {
                        self.presentAlertOnMainThread(title: "Success", message: "You have successfully added this user to favorite 🎉", buttonTitle: "Hooray")
                        return
                    }
                    self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    
                }
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListViewController: UICollectionViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y // How far we've scrolled in the Y direction
        let contentHeight = scrollView.contentSize.height //height of the scroll view determined by all its content
        let height = scrollView.frame.size.height // height of the users phone screen.
        
        if height > contentHeight - offsetY{
            guard hasMoreFollowers, !isLoadingMoreFollowers else{ return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollower : follower
        let follower = activeArray[indexPath.item]
        
        let destinationVC = UserInfoViewController()
        destinationVC.delegate = self
        destinationVC.username = follower.login
        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true)
        
    }
}

extension FollowerListViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else{
            updateData(for: follower)
            filteredFollower.removeAll()
            isSearching = false
            return
        }
        isSearching = true
        filteredFollower = follower.filter{$0.login.lowercased().contains(filter.lowercased()) }
        updateData(for: filteredFollower)
    }
}

extension FollowerListViewController: UserInfoVCDelegate
{
    
    func didRequestFollower(for username: String) {
        // reset the page and make the network call again
        
        self.username = username
        title = username
        page = 1
        //collectionView.setContentOffset(.init(x: 0, y: -200), animated: true)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        follower.removeAll()
        filteredFollower.removeAll()
        getFollowers(username: username, page: page)
    }
    
}
