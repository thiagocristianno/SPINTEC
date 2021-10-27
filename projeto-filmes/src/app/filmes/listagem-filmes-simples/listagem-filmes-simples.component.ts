import { Component, OnInit } from '@angular/core';
import { FilmesService } from 'src/app/core/filmes.service';
import { Filme } from 'src/app/shared/models/filme';
import { FormGroup, FormBuilder } from '@angular/forms';
import { ConfigParams } from 'src/app/shared/models/configParams';
import { debounceTime} from 'rxjs/operators';
import { Router } from '@angular/router';
import { of } from 'rxjs';
import { tap, delay } from 'rxjs/operators';

@Component({
  selector: 'dio-listagem-filmes-simples',
  templateUrl: './listagem-filmes-simples.component.html',
  styleUrls: ['./listagem-filmes-simples.component.scss']
})
export class ListagemFilmesSimplesComponent implements OnInit {

  readonly semFoto = 'https://www.termoparts.com.br/wp-content/uploads/2017/10/no-image.jpg';

  config: ConfigParams = {
    pagina: 0,
    limite: 4
  };

  filmes: Filme[] = [];
  filtrosListagem: FormGroup;
  generos: Array<string>;

  constructor(private filmesService: FilmesService,
              private fb: FormBuilder, private router: Router) { }

  ngOnInit(): void {
     this.filtrosListagem = this.fb.group({
       texto: [''],
       genero: ['']
     });

     this.filtrosListagem.get('texto').valueChanges.pipe(debounceTime(400))
     .subscribe((val: string) => {
        this.config.pesquisa = val;
        this.resetarConsulta();
     })

     this.filtrosListagem.get('genero').valueChanges.subscribe((val: string) => {
        this.config.campo = {tipo: 'genero', valor: val};
        this.resetarConsulta();
    })
     
     this.generos = ['Ação', 'Romance', 'Aventura', 'Terror', 'Ficção científica', 'Comédia', 'Drama'];

     this.listarFilmes();
  }

  onScroll(): void {
    this.listarFilmes();
  }

  abrir(id: number): void {
    this.router.navigateByUrl('/filmes/' + id);
  }

  private listarFilmes(): void {
    this.config.pagina++;
    this.filmesService.listar(this.config)
    .subscribe((filmes: Filme[]) => this.filmes.push(...filmes)); // ... entende que vai receber uma lista
  }

  private resetarConsulta(): void {
     this.config.pagina = 0;
     this.filmes = [];
     this.listarFilmes();
  }

}