const fragment = new DocumentFragment();
const url = 'http://localhost:3000/datas';


fetch(url)
    .then((res) => {
        return res.json()
    })
    .then((exams) => {
        exams.forEach(exam => {
            const tBory = document.getElementById("tbory") 
            let newRow = tBory.insertRow(-1)
            newRow.insertCell(0).textContent = `${exam.token_resultado_exame}`
            newRow.insertCell(1).textContent = `${exam.nome_paciente}`
            newRow.insertCell(2).textContent = `${exam.cpf}`
            newRow.insertCell(3).textContent = `${exam.nome_medico}`
            newRow.insertCell(4).textContent = `${exam.tipo_exame}`
            newRow.insertCell(5).textContent = `${exam.resultado_tipo_exame}`
            newRow.insertCell(6).textContent = `${exam.limites_tipo_exame}`
            newRow.insertCell(7).textContent = `${exam.data_exame}`
        })
    })
    .catch(() => {
        const reportError = document.getElementById("error") 
        reportError.classList.add("alert", "alert-warning")
        reportError.textContent = "Ops, ocorreu um erro."
  })

  