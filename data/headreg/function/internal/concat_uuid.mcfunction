# headreg:internal/concat_uuid —— 拼标准 UUID（由 _work/headreg/_gen.mjs 生成，勿手改）
# 入口：storage headreg:tmp uu = {c0..c31}（字符串）
$data modify storage headreg:data root.working_data.uuid_str set value "$(c0)$(c1)$(c2)$(c3)$(c4)$(c5)$(c6)$(c7)-$(c8)$(c9)$(c10)$(c11)-$(c12)$(c13)$(c14)$(c15)-$(c16)$(c17)$(c18)$(c19)-$(c20)$(c21)$(c22)$(c23)$(c24)$(c25)$(c26)$(c27)$(c28)$(c29)$(c30)$(c31)"
