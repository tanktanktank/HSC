//
//  StockHeadView.swift
//  test
//
//  Created by tfr on 2022/4/19.
//

import UIKit

protocol StockHeadViewDelegate : NSObjectProtocol {
    ///点击充值
    func clickRecharge()
    ///点击提现
    func clickWithdraw()
    ///点击划转
    func clickTransfer()
    ///点击历史记录
    func clickhHstory()
    ///点击隐藏显示
    func clickSeeBtn(model:SpotcointotalModel,isHiddenSee : Bool)
    
}
class StockHeadView: UIView {

    public weak var delegate: StockHeadViewDelegate? = nil
    lazy var topLine : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var bgView : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("1E1E1E")
        return v
    }()
    lazy var bottomLine : UIView = {
        let v = UIView()
        v.backgroundColor = .hexColor("000000")
        return v
    }()
    lazy var totalTitleLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTB(size: 10)
        lab.textColor = .hexColor("989898")
//        lab.text = "Total Value(BTC)"
        return lab
    }()
    lazy var totalLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTDIN(size: 26)
        lab.textColor = .hexColor("EBEBEB")
        lab.adjustsFontSizeToFitWidth = true
        lab.text = "-"
        return lab
    }()
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.font = FONTDIN(size: 12)
        lab.textColor = .hexColor("989898")
        lab.text = "-"
        return lab
    }()
    
    ///充值
    lazy var rechargeBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .hexColor("FCD283")
        btn.layer.cornerRadius = 2
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.hexColor("1E1E1E"), for: .normal)
        btn.setTitle("tv_home_desposit".localized(), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.addTarget(self, action: #selector(tapRechargeBtn), for: .touchUpInside)
        return btn
    }()
    ///提现
    lazy var withdrawBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.layer.cornerRadius = 2
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.setTitle("tv_fund_withdraw".localized(), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.addTarget(self, action: #selector(tapWithdrawBtn), for: .touchUpInside)
        return btn
    }()
    ///划转
    lazy var transferBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .hexColor("2D2D2D")
        btn.layer.cornerRadius = 2
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.hexColor("FFFFFF"), for: .normal)
        btn.setTitle("tv_fund_tran".localized(), for: .normal)
        btn.titleLabel?.font = FONTM(size: 13)
        btn.addTarget(self, action: #selector(tapTransferBtn), for: .touchUpInside)
        return btn
    }()
    lazy var seeBtn : ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "wallets_see"), for: .normal)
        btn.setImage(UIImage(named: "wallets_nosee"), for: .selected)
        btn.addTarget(self, action: #selector(tapSeeBtn), for: .touchUpInside)
        btn.isSelected = false
        return btn
    }()
    ///昨日收益
    lazy var yesterView : YesterdaView = {
        let v = YesterdaView()
        return v
    }()
    ///历史记录
    lazy var hisBtn : ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "wallets_history"), for: .normal)
        btn.addTarget(self, action: #selector(tapHisBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var pieChartView = PieChartView()
    lazy var baseView : UIView = {
        let v = UIView()
        return v
    }()
    var datas : [Double] = []
    var values = [PieChartDataEntry]()
    var colors : [UIColor] = []
    
    func setModelForHidden(model : SpotcointotalModel,isHiddenSee:Bool){
        self.model = model
        totalTitleLab.text = "tv_fund_total_value".localized() + "(\(model.base_coin))"
        totalLab.text = self.addMicrometerLevel(valueSwift: model.base_num)
        if isHiddenSee {
            totalLab.text = "******"
            detailLab.text = "******"
            yesterView.earningsLab.text = "******"
        }else{
            let f1 = Float(model.usdt_total) ?? 0.0
            let str1 = String(format: "%.2f", f1)
            detailLab.text = "≈" + self.addRateTwoDecimalsSymbol(value: str1)
            
            let f = Float(model.ratio_num) ?? 0.0
            let str = String(format: "%.2f", f)
            yesterView.earningsLab.text = "\(self.addRateTwoDecimalsSymbol(value: str))/\(self.addPriceDecimals(value: model.ratio_str, digit: "2"))%"
        }
        colors.removeAll()
        if model.coin_proportion_list.count == 4 {
            colors = [.hexColor("F2ACAB"),.hexColor("46BEA2"),.hexColor("2FCAD9"),.hexColor("EFEDB7")]
        }else if model.coin_proportion_list.count == 3{
            colors = [.hexColor("F2ACAB"),.hexColor("46BEA2"),.hexColor("2FCAD9")]
        }else if model.coin_proportion_list.count == 2{
            colors = [.hexColor("F2ACAB"),.hexColor("46BEA2")]
        }else{
            colors = [.hexColor("F2ACAB")]
        }
        datas.removeAll()
        values.removeAll()
        for tmp in model.coin_proportion_list {
            let proportion = tmp.proportion_str
            let coin = tmp.coin
            let labStr = "\(coin)：\(proportion)%"
            let num : Double = getDoubleWithString(str: proportion)
            datas.append(num)
            values.append(PieChartDataEntry(value: num, label: labStr))
        }
        setPieChartView()
        var legendViewX : CGFloat = 0
        var legendViewY : CGFloat = 0
        let legendViewW : CGFloat = SCREEN_WIDTH/4.0
        let legendViewH : CGFloat = 15
        self.baseView.qmui_removeAllSubviews()
        if model.coin_proportion_list.count == 1 {
            let tmpModel = model.coin_proportion_list.safeObject(index: 0)
            let color = colors.safeObject(index: 0)
            let vaule = tmpModel?.proportion_str ?? ""
            let legendView = LegendView()
            legendView.colorV.backgroundColor = color
            legendView.titleLab.text = tmpModel?.coin
            legendView.vauleLab.text = "\(vaule)%"
            self.baseView.addSubview(legendView)
            legendView.size = CGSize(width: legendViewW, height: legendViewH*2)
            legendView.center = CGPoint(x: legendViewW, y: legendViewH)
            return
        }
        for i in stride(from: 0, to: model.coin_proportion_list.count ,by: 1) {
            let tmpModel = model.coin_proportion_list.safeObject(index: i)
            let color = colors.safeObject(index: i)
            let vaule = tmpModel?.proportion_str ?? ""
            
            let legendView = LegendView()
            legendView.colorV.backgroundColor = color
            legendView.titleLab.text = tmpModel?.coin
            
            legendView.vauleLab.text = "\(vaule)%"
            self.baseView.addSubview(legendView)
            legendView.frame = CGRect(x: legendViewX, y: legendViewY, width: legendViewW, height: legendViewH)
            legendViewX = legendViewX + legendViewW
            if legendViewX >= legendViewW*2{
                legendViewX = 0
                legendViewY = legendViewY+legendViewH
            }
        }
        
    }
    var model : SpotcointotalModel = SpotcointotalModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        initSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK: 事件点击
extension StockHeadView{
    ///点击充值
    @objc func tapRechargeBtn(){
        self.delegate?.clickRecharge()
    }
    ///点击提现
    @objc func tapWithdrawBtn(){
        self.delegate?.clickWithdraw()
    }
    ///点击划转
    @objc func tapTransferBtn(){
        self.delegate?.clickTransfer()
    }
    ///点击历史记录
    @objc func tapHisBtn(){
        self.delegate?.clickhHstory()
    }
    //MARK: 点击隐藏和显示
    @objc func tapSeeBtn(sender : ZQButton){
//        setDataWith(isSee: sender.isSelected)
        sender.isSelected = !sender.isSelected
        self.delegate?.clickSeeBtn(model: self.model, isHiddenSee: sender.isSelected)
    }
    
}
//MARK: ui
extension StockHeadView{
    func setPieChartView(){
        let dataSet = PieChartDataSet(values: values, label: "")

        let data = PieChartData(dataSet: dataSet)
        //是否显示数值。默认true
        dataSet.drawValuesEnabled = false
        pieChartView.data = data
        pieChartView.usePercentValuesEnabled = true
        pieChartView.holeColor = .clear
        //是否显示图例
        pieChartView.legend.enabled = false
        //是否显示数值。默认true
        dataSet.drawValuesEnabled = false
        //文字显示位置。默认insideSlice
        dataSet.xValuePosition = .outsideSlice
        //文字显示位置。默认insideSlice
        dataSet.yValuePosition = .outsideSlice
        //文字大小
        dataSet.entryLabelFont = .systemFont(ofSize: 20)
        //文字颜色
        dataSet.entryLabelColor = .clear

        //yValuePosition == .outsideSlice 时生效，指示线颜色和饼图切片颜色相同。默认false
        dataSet.useValueColorForLine = false
        //yValuePosition == .outsideSlice 时生效，指示线颜色。抵消useValueColorForLine。默认black
        //dataSet.valueLineColor = .red
        //yValuePosition == .outsideSlice 时生效，指示线宽度。默认1.0
        dataSet.valueLineWidth = 0
        //yValuePosition == .outsideSlice 时生效，指示线偏移量占饼图百分比。默认0.75
        dataSet.valueLinePart1OffsetPercentage = 0.75
        //yValuePosition == .outsideSlice 时生效，指示线前半部分长度占饼图百分比。默认0.3
        dataSet.valueLinePart1Length = 0.3
        //yValuePosition == .outsideSlice 时生效，指示线后半部分长度占饼图百分比。默认0.4
        dataSet.valueLinePart2Length = 0.4
        //yValuePosition == .outsideSlice 时生效，指示线后半部分长度占饼图百分比。默认0.4
        //yValuePosition == .outsideSlice 时生效，旋转饼图时，是否动态改变指示线的长度。默认true
        dataSet.valueLineVariableLength = true
        //饼图选中后的颜色
//        dataSet.highlightColor = .purple
        //饼图距离边距距离。默认18
        dataSet.selectionShift = 10
        //饼片之间的距离。默认0.0
        dataSet.sliceSpace = 0
        //各饼片颜色
        dataSet.colors = colors
        //默认NO
        dataSet.automaticallyDisableSliceSpacing = false
    }
    func setUI() {
        rechargeBtn.isSelected = true
        self.addSubview(topLine)
        self.addSubview(bgView)
        self.addSubview(bottomLine)
        bgView.addSubview(totalTitleLab)
        bgView.addSubview(totalLab)
        bgView.addSubview(detailLab)
        bgView.addSubview(rechargeBtn)
        bgView.addSubview(withdrawBtn)
        bgView.addSubview(transferBtn)
        bgView.addSubview(seeBtn)
        bgView.addSubview(yesterView)
        bgView.addSubview(pieChartView)
        bgView.addSubview(baseView)
        bgView.addSubview(hisBtn)
        
    }
    func initSubViewsConstraints() {
        self.topLine.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        self.bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topLine.snp.bottom)
            make.height.equalTo(200)
        }
        self.bottomLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.bgView.snp.bottom)
            make.height.equalTo(5)
        }
        totalTitleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(20)
        }
        seeBtn.snp.makeConstraints { make in
            make.left.equalTo(totalTitleLab.snp.right).offset(5)
            make.centerY.equalTo(totalTitleLab)
            make.width.equalTo(20)
            make.height.equalTo(25)
        }
        totalLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(pieChartView.snp.left).offset(-20)
            make.top.equalTo(totalTitleLab.snp.bottom).offset(5)
        }
        detailLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.right.equalTo(pieChartView.snp.left)
            make.top.equalTo(totalLab.snp.bottom).offset(5)
        }
        yesterView.snp.makeConstraints { make in
            make.left.equalTo(totalTitleLab)
            make.top.equalTo(detailLab.snp.bottom).offset(12)
        }
        let spaceW = (SCREEN_WIDTH - 110*3 - LR_Margin*2)/2.0
        
        rechargeBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(LR_Margin)
            make.width.equalTo(110)
            make.height.equalTo(33)
        }
        withdrawBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalTo(rechargeBtn.snp.right).offset(spaceW)
            make.width.equalTo(110)
            make.height.equalTo(33)
        }
        transferBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalTo(withdrawBtn.snp.right).offset(spaceW)
            make.width.equalTo(110)
            make.height.equalTo(33)
        }
        hisBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-LR_Margin)
            make.centerY.equalTo(totalTitleLab)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        baseView.snp.makeConstraints { make in
            make.left.equalTo(bgView.snp.centerX)
            make.right.equalToSuperview()
            make.top.equalTo(yesterView)
            make.height.equalTo(30)
        }
        pieChartView.snp.makeConstraints { make in
            make.centerY.equalTo(totalLab)
            make.centerX.equalTo(bgView.snp.centerX).offset(SCREEN_WIDTH/4.0)
            make.width.height.equalTo(80)
        }
    }
}
