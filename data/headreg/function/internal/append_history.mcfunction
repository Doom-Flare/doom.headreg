# headreg:internal/append_history —— 把 root.session 追加进分桶历史，并裁到最近 10 段
# 前置：root.target_id、root.session 已就绪；必须在 push_data 之后调用（push 会整体覆盖 data）
$data modify storage headreg:data root.$(target_id).data.history append from storage headreg:data root.session
$execute store result score #hlen headreg.calc run data get storage headreg:data root.$(target_id).data.history
$execute if score #hlen headreg.calc matches 11.. run data remove storage headreg:data root.$(target_id).data.history[0]
