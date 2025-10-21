<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Thành viên CLB</title>
    <style>
        body { font-family: 'Roboto', Arial, sans-serif; margin: 0; background: #f9f9fb; color: #333; }
        .container {
            max-width: 1200px; margin: 40px auto; background: #fff; padding: 30px;
            border-radius: 12px; box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }

        /* 🔎 Thanh tìm kiếm */
        .filter-bar { display: flex; gap: 12px; margin-bottom: 18px; flex-wrap: wrap; }
        .filter-bar input[type="text"] {
            flex: 1; min-width: 260px; padding: 10px 12px; border: 1px solid #ccc; border-radius: 6px;
            transition: border-color .2s, box-shadow .2s;
        }
        .filter-bar input[type="text"]:focus {
            border-color: #5E35B1; box-shadow: 0 0 0 2px rgba(94,53,177,0.2); outline: none;
        }
        .filter-bar button {
            background-color: #5E35B1; color: #fff; border: none; padding: 10px 18px; border-radius: 6px;
            cursor: pointer; font-weight: 500; transition: background-color .2s;
        }
        .filter-bar button:hover { background-color: #4527A0; }

        /* 🧾 Bảng */
        table { border-collapse: collapse; width: 100%; border-radius: 8px; overflow: hidden; }
        th, td { padding: 12px 16px; text-align: left; }
        th { background: #5E35B1; color: #fff; font-weight: 600; white-space: nowrap; }
        tr:nth-child(even) { background: #f8f6fc; }
        tr:hover { background: #ede7f6; transition: background .2s; }
        img.avatar { border-radius: 6px; width: 50px; height: 50px; object-fit: cover; }

        /* ⬆⬇ nút sort trên tiêu đề cột */
        .sort { cursor: pointer; user-select: none; font-size: 12px; margin-left: 8px; padding: 2px 6px;
                border-radius: 4px; background: rgba(255,255,255,0.18); color: #fff; }
        .sort.active { background: #fff; color: #5E35B1; font-weight: 700; }

        /* 🔢 Phân trang */
        .pagination-wrap { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-top: 16px; }
        .page-size { display: flex; align-items: center; gap: 8px; color: #555; }
        .page-size select { padding: 8px 10px; border: 1px solid #ccc; border-radius: 6px; }
        .pagination { display: flex; gap: 6px; flex-wrap: wrap; }
        .pagination button {
            padding: 8px 12px; border: 1px solid #ddd; background: #fff; color: #5E35B1;
            border-radius: 6px; cursor: pointer;
        }
        .pagination button:hover { background: #f3e5f5; }
        .pagination button.active {
            background: #5E35B1; color: #fff; border-color: #5E35B1; font-weight: 600;
        }
        .pagination button:disabled { opacity: .5; cursor: not-allowed; }
        .range-info { color: #777; }

        @media (max-width: 768px) { table, th, td { font-size: 14px; } }
    </style>
</head>
<body>

    
    <jsp:include page="/view/layout/header.jsp" />

    <div class="container">

        
        <div class="filter-bar">
            <input id="globalSearch" type="text" placeholder="Tìm (UserID, FullName, RoleInClub, JoinDate)..." />
            <button id="btnSearch" type="button">Search</button>
        </div>

        <table id="memberTable">
            <thead>
            <tr>
                <th> UserID   <span class="sort" data-col="0" data-type="number" data-dir="asc">▲</span></th>
                <th> FullName <span class="sort" data-col="1" data-type="text"   data-dir="asc">▲</span></th>
                <th> RoleInClub <span class="sort" data-col="2" data-type="text" data-dir="asc">▲</span></th>
                <th> ProfileImage </th>
                <th> JoinDate <span class="sort" data-col="4" data-type="date"   data-dir="asc">▲</span></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="m" items="${members}">
                <tr>
                    <td>${m.userId}</td>
                    <td>${m.fullName}</td>
                    <td>${m.roleInClub}</td>
                    <td>
                        <c:choose>
                            <c:when test="${empty m.profileImage}">
                                <img class="avatar" src="${pageContext.request.contextPath}/images/default-avatar.png" alt="avatar"/>
                            </c:when>
                            <c:otherwise>
                                <img class="avatar" src="${pageContext.request.contextPath}/images/${m.profileImage}" alt="avatar"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><c:out value="${not empty m.joinDateDisplay ? m.joinDateDisplay : m.joinDate}" /></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        
        <div class="pagination-wrap">
            <div class="page-size">
                Show
                <select id="pageSize">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                </select>
                
            </div>
            <div class="range-info" id="rangeInfo"></div>
            <div class="pagination" id="pagination"></div>
        </div>
    </div>

    <jsp:include page="/view/layout/footer.jsp" />

<script>
(function(){
  const table = document.getElementById('memberTable');
  const tbody = table.tBodies[0];
  const search = document.getElementById('globalSearch');
  const btnSearch = document.getElementById('btnSearch');
  const sorters = Array.from(document.querySelectorAll('.sort'));
  const pageSizeSel = document.getElementById('pageSize');
  const paginationEl = document.getElementById('pagination');
  const rangeInfoEl = document.getElementById('rangeInfo');

  let state = {
    page: 1,
    size: parseInt(pageSizeSel.value, 10)
  };

  function norm(s){ return (s||'').toString().toLowerCase().trim(); }
  function cellText(row, col){ return row.cells[col].innerText.trim(); }

 
  function parseDateVN(s){
    s = (s||'').trim();
    if(!s) return 0;
    const [dpart, tpart='00:00'] = s.split(' ');
    const [d,m,y] = dpart.split('/').map(n=>parseInt(n,10));
    const [hh,mm] = tpart.split(':').map(n=>parseInt(n,10));
    return new Date(y, (m||1)-1, d||1, hh||0, mm||0).getTime();
  }

  function cmp(a, b, type, dir){
    let va=a, vb=b;
    if(type==='number'){ va=parseFloat(a)||0; vb=parseFloat(b)||0; }
    else if(type==='date'){ va=parseDateVN(a); vb=parseDateVN(b); }
    else { va=norm(a); vb=norm(b); }
    const res = va<vb ? -1 : (va>vb ? 1 : 0);
    return dir==='asc' ? res : -res;
  }

  function sortBy(col, type, dir){
    const rows = Array.from(tbody.rows);
    rows.sort((r1, r2) => cmp(cellText(r1,col), cellText(r2,col), type, dir))
        .forEach(r => tbody.appendChild(r));
  }

  function filteredRows(){
    const q = norm(search.value);
    const all = Array.from(tbody.rows);
    if(!q) return all;
    return all.filter(r => {
      const hay = norm([0,1,2,4].map(i => r.cells[i].innerText).join(' '));
      return hay.includes(q);
    });
  }

  function renderPagination(totalPages){
    paginationEl.innerHTML = '';
    
    const prevBtn = document.createElement('button');
    prevBtn.textContent = 'Prev';
    prevBtn.disabled = state.page <= 1;
    prevBtn.onclick = () => { if(state.page>1){ state.page--; paginate(); } };
    paginationEl.appendChild(prevBtn);

    
    for(let p=1; p<=totalPages; p++){
      const b = document.createElement('button');
      b.textContent = p;
      if(p===state.page) b.classList.add('active');
      b.onclick = () => { state.page = p; paginate(); };
      paginationEl.appendChild(b);
    }

    
    const nextBtn = document.createElement('button');
    nextBtn.textContent = 'Next';
    nextBtn.disabled = state.page >= totalPages;
    nextBtn.onclick = () => { if(state.page<totalPages){ state.page++; paginate(); } };
    paginationEl.appendChild(nextBtn);
  }

  function paginate(){
    const all = Array.from(tbody.rows);
    all.forEach(r => r.style.display = 'none');

    const filtered = filteredRows();
    const total = filtered.length;
    const size = state.size;
    const totalPages = Math.max(1, Math.ceil(total / size));

    
    if(state.page > totalPages) state.page = totalPages;
    if(state.page < 1) state.page = 1;

    const start = (state.page - 1) * size;
    const end = start + size;

    filtered.slice(start, end).forEach(r => r.style.display = '');

    
    const from = total === 0 ? 0 : (start + 1);
    const to = Math.min(end, total);
    

    renderPagination(totalPages);
  }

  sorters.forEach(s => {
    s.addEventListener('click', () => {
      sorters.forEach(x => { if(x!==s){ x.dataset.dir='asc'; x.textContent='▲'; x.classList.remove('active'); } });
      const col = parseInt(s.dataset.col,10);
      const type = s.dataset.type;
      const dir = s.dataset.dir === 'asc' ? 'desc' : 'asc';
      s.dataset.dir = dir;
      s.textContent = dir==='asc' ? '▲' : '▼';
      s.classList.add('active');
      sortBy(col, type, dir);
      state.page = 1;
      paginate();
    });
  });

  
  function applySearch(){ state.page = 1; paginate(); }
  search.addEventListener('input', applySearch);
  btnSearch.addEventListener('click', applySearch);

  
  pageSizeSel.addEventListener('change', () => {
    state.size = parseInt(pageSizeSel.value, 10) || 10;
    state.page = 1;
    paginate();
  });

  
  paginate();
})();
</script>

</body>
</html>
